# Detection Video Player — Flow Documentation

> **File Utama:** `lib/view/video/detection_video_player_page.dart`
> **Fitur:** Real-time Age/Gender Detection → Campaign Asset Matching → Targeted Playback

---

## Daftar Isi

1. [Gambaran Umum](#1-gambaran-umum)
2. [Arsitektur & Komponen](#2-arsitektur--komponen)
3. [State Machine](#3-state-machine)
4. [Flow Lengkap](#4-flow-lengkap)
   - [4.1 Inisialisasi](#41-inisialisasi)
   - [4.2 Camera Frame Processing](#42-camera-frame-processing)
   - [4.3 Face Detection & Filter](#43-face-detection--filter)
   - [4.4 ONNX Inference (Age/Gender Prediction)](#44-onnx-inference-agegender-prediction)
   - [4.5 Prediction Consensus](#45-prediction-consensus)
   - [4.6 Asset Matching (Database Query)](#46-asset-matching-database-query)
   - [4.7 Playback (Default & Targeted)](#47-playback-default--targeted)
   - [4.8 Face Tracking & Impression](#48-face-tracking--impression)
   - [4.9 Error Handling & SUPERFK State](#49-error-handling--superfk-state)
   - [4.10 Cleanup & Dispose](#410-cleanup--dispose)
5. [Diagram Alur](#5-diagram-alur)
6. [Detail Fungsi Per File](#6-detail-fungsi-per-file)

---

## 1. Gambaran Umum

`DetectionVideoPlayerPage` adalah halaman utama yang mengintegrasikan seluruh pipeline deteksi wajah hingga penayangan iklan bertarget. Sistem ini bekerja secara real-time:

1. **Deteksi Wajah** via kamera depan menggunakan Google MLKit
2. **Prediksi Usia & Gender** menggunakan model ONNX (ResNet18 atau FastViT)
3. **Matching Campaign** — hasil prediksi dicocokkan dengan database campaign/aset visual
4. **Targeted Playback** — menampilkan aset iklan yang sesuai dengan demografi penonton
5. **Impression Tracking** — mencatat data audience untuk analytics

---

## 2. Arsitektur & Komponen

```
DetectionVideoPlayerPage
├── OnnxService                  → Inference model AI (age/gender)
├── PlaybackController           → Manajemen video/image playback
├── ImpressionTracker            → Analytics & impression recording
├── FaceTrackingService          → Stable face ID & change detection
├── PlaybackTimerManager         → Centralized timer management
├── FaceDetectionUtils           → Filter & validasi wajah
├── PredictionConsensus          → Agregasi hasil prediksi
├── VisualAssetDb                → Query campaign matching dari DB
└── PersonCropHelper             → Crop person/face untuk inference
```

| File                                              | Tanggung Jawab                                    |
| ------------------------------------------------- | ------------------------------------------------- |
| `detection_video_player_page.dart`                | Orchestrator utama, UI, state management          |
| `services/onnx_service.dart`                      | Load model & jalankan inference ONNX              |
| `helper/face_detection_utils.dart`                | Filter wajah valid (ukuran, sudut)                |
| `helper/prediction_result.dart`                   | Consensus mechanism (median age, majority gender) |
| `services/impression_tracker.dart`                | Rekam impression per wajah per aset               |
| `services/face_tracking_service.dart`             | Resolusi face ID yang stabil                      |
| `helper/playback_timer_manager.dart`              | Manajemen semua timer deteksi                     |
| `view/video/controllers/playback_controller.dart` | Playback video/image, error handling              |

---

## 3. State Machine

```
                    ┌─────────────────────────────────────────────┐
                    │                   IDLE                       │
                    └─────────────────┬───────────────────────────┘
                                      │ _initialize() selesai
                                      ▼
                    ┌─────────────────────────────────────────────┐
                    │                SCANNING                      │
                    │  (default assets playing, kamera aktif)      │
                    └──────────┬──────────────────────────────────┘
                               │ wajah terdeteksi & valid
                               ▼
                    ┌─────────────────────────────────────────────┐
                    │               DETECTING                      │
                    │  (ONNX inference berjalan)                   │
                    └──────────┬──────────────────────────────────┘
                               │ consensus selesai
                    ┌──────────┴──────────────────────────────────┐
                    │                                              │
                    ▼                                              ▼
     ┌──────────────────────────┐            ┌────────────────────────────────┐
     │     PLAYING DEFAULT      │            │      PLAYING TARGETED          │
     │  (tidak ada match di DB) │            │  (campaign sesuai demografi)   │
     └──────────────────────────┘            └────────────────────────────────┘
                                                          │ error rate tinggi
                                                          ▼
                                             ┌────────────────────────────────┐
                                             │          SUPERFK               │
                                             │   (critical error state)       │
                                             └────────────────────────────────┘
```

**Transisi state dikelola oleh `PlaybackController`.**

---

## 4. Flow Lengkap

### 4.1 Inisialisasi

**Fungsi:** `_initialize()` di `detection_video_player_page.dart`

```
_initialize()
├── Baca preferences (screenId, locationId, model type)
├── OnnxService.loadModel()
│   ├── Tentukan model: ResNet18 atau FastViT
│   └── Init session ONNX (CPU/GPU/NNAPI)
├── PlaybackController.loadDefaultAssets()
│   └── Query DB → ambil default playlist aset
├── Init kamera depan (resolusi rendah untuk performa)
├── Init ImpressionTracker(screenId, locationId)
├── Daftarkan MethodChannel 'advatar/playlist_reload'
│   └── Listener untuk hot-reload playlist dari luar
├── Mulai camera stream (_startCameraStream)
├── PlaybackTimerManager.startStatusLogger()  → log status tiap 3 detik
└── PlaybackTimerManager.startCleanupTimer()  → cleanup stale face tiap 1 detik
```

---

### 4.2 Camera Frame Processing

**Fungsi:** `_processImage(CameraImage image)` — dipanggil setiap frame kamera

```
_processImage(image)
├── Cek: apakah sedang memproses? (_isProcessingFrame) → skip jika ya
├── Cek: apakah dalam SUPERFK state? → stop semua proses
├── Frame skipping: skip N frame sebelum diproses (untuk performa)
│
├── Convert CameraImage → InputImage (MLKit format)
│   └── CameraUtils.convertCameraImageToInputImage()
│
├── FaceDetector.processImage(inputImage)
│   └── Deteksi semua wajah di frame
│
├── FaceTrackingService.trackFaces(allFaces)
│   └── Update lastSeenTime semua face yang terdeteksi
│
├── FaceDetectionUtils.getPriorityFace(faces, imageSize)
│   └── [Lihat 4.3 untuk detail]
│
├── Jika status == noFaceFound:
│   ├── StartNoPersonTimer (5 detik)
│   │   └── Jika timeout: kembali ke default playback
│   └── Return
│
├── Jika status == tooFar / badAngle:
│   ├── Update UI indicator
│   └── Return (tidak lanjut ke inference)
│
└── Jika status == readyToProcess:
    ├── CancelNoPersonTimer
    └── _runOnnxInference(image, face)
```

---

### 4.3 Face Detection & Filter

**File:** `lib/helper/face_detection_utils.dart`
**Fungsi:** `FaceDetectionLogic.getPriorityFace(faces, imageSize)`

```
getPriorityFace(faces, imageSize)
├── Jika tidak ada wajah → return {status: noFaceFound}
│
├── Pilih wajah terbesar (berdasarkan luas bounding box)
│
├── Validasi ukuran:
│   └── width >= 20% dari sisi terpendek gambar?
│       └── Tidak → return {status: tooFar, msg: "Dekatkan wajah"}
│
├── Validasi sudut horizontal (headEulerAngleY):
│   └── |angleY| > 25°?
│       └── Ya → return {status: tooFar, msg: "Hadapkan wajah ke depan"}
│
├── Validasi kemiringan kepala (headEulerAngleZ):
│   └── |angleZ| > 25°?
│       └── Ya → return {status: tooFar, msg: "Luruskan kepala"}
│
└── Semua valid → return {status: readyToProcess, face: priorityFace}
```

**Status yang dihasilkan:**

| Status           | Pesan UI                                                   | Aksi                  |
| ---------------- | ---------------------------------------------------------- | --------------------- |
| `noFaceFound`    | "Arahkan wajah ke kamera"                                  | Start no-person timer |
| `tooFar`         | "Dekatkan wajah" / "Hadapkan ke depan" / "Luruskan kepala" | Tampilkan hint        |
| `readyToProcess` | "Memproses..."                                             | Lanjut ke inference   |

---

### 4.4 ONNX Inference (Age/Gender Prediction)

**Fungsi:** `_runOnnxInference(CameraImage image, Face face)`

```
_runOnnxInference(image, face)
├── Cek: apakah state memperbolehkan inference?
│   ├── Jika sedang playingTargeted → inference sparse (tiap 5 detik saja)
│   └── Jika sedang scanning/detecting → inference normal
│
├── Cek: apakah inference sedang berjalan? → skip jika ya
│
├── Tentukan mode crop berdasarkan model:
│   ├── ResNet18 → crop wajah saja (FaceDetectionUtils.cropFace)
│   └── FastViT  → crop seluruh badan (PersonCropHelper.cropPerson)
│
├── Convert CameraImage → img.Image (format gambar)
│
├── OnnxService.predict(croppedImage)
│   ├── _preprocessImage():
│   │   ├── Resize ke 384×384
│   │   └── Normalisasi ImageNet:
│   │       ├── mean = [0.485, 0.456, 0.406]
│   │       └── std  = [0.229, 0.224, 0.225]
│   ├── Jalankan session ONNX
│   └── Parse output:
│       ├── ResNet18: gender (2-class softmax) + age (single value)
│       └── FastViT:  age_multiplier_100 (0-1) + gender_logits (2-class)
│
├── Hasil: { gender, genderConfidence, age, model }
│
└── PredictionConsensus.addSample(result)
    └── [Lihat 4.5 untuk detail]
```

---

### 4.5 Prediction Consensus

**File:** `lib/helper/prediction_result.dart`
**Class:** `PredictionConsensus`

```
addSample(prediction)
├── Tambahkan ke daftar sampel
│
├── Cek: jumlah sampel >= requiredSamples? (default: 1)
│   └── Tidak → tunggu sampel berikutnya (timeout 10 detik)
│
├── Hitung hasil akhir:
│   ├── Age    → median dari semua sampel
│   ├── Gender → majority vote (male vs female)
│   └── Confidence → rata-rata confidence
│
├── Lock consensus (tidak menerima sampel baru)
│
└── Panggil _onDetectionComplete(result)
```

**Timeout Behavior:**

- Jika tidak ada sampel baru dalam 10 detik → reset consensus, ulangi dari awal

---

### 4.6 Asset Matching (Database Query)

**Fungsi:** `_processDetectionResult(PredictionResult result)`

```
_processDetectionResult(result)
├── Ekstrak: gender (Male/Female), age (0-100)
│
├── Tentukan age group berdasarkan rentang usia:
│   └── Contoh: 18-24, 25-34, 35-44, dst.
│
├── VisualAssetDb.getCampaignsForTarget(gender, ageGroup)
│   └── Query SQLite:
│       "SELECT assets WHERE gender = ? AND age_group = ?"
│
├── JIKA ada campaign yang cocok:
│   ├── FaceTrackingService.seedInitialFace(gender, age)
│   ├── ImpressionTracker.onDetectionComplete(gender, age)
│   └── PlaybackController.switchToTargetedPlayback(assets)
│       └── [Mulai Targeted Playback — lihat 4.7]
│
└── JIKA tidak ada campaign:
    ├── Tampilkan NoMatchIndicator di UI
    ├── Catat di log
    └── Lanjutkan Default Playback
```

---

### 4.7 Playback (Default & Targeted)

**File:** `lib/view/video/controllers/playback_controller.dart`

#### Default Playback

```
PlaybackController.switchToDefaultPlayback()
├── Set _currentPlaylist = _defaultAssets
├── Reset index ke 0
└── playAsset(currentAsset)
    ├── Jika video → _playVideoOptimized()
    └── Jika image → _showImage()
```

#### Targeted Playback

```
PlaybackController.switchToTargetedPlayback(campaignAssets)
├── Set _currentPlaylist = campaignAssets
├── ImpressionTracker.startPlayback(campaignId, assetId)
└── playAsset(firstAsset)
```

#### playAsset()

```
playAsset(asset)
├── Validasi file: exists? readable? size > 0?
│
├── JIKA VIDEO:
│   ├── Cek resolusi ≤ 1920×1080
│   ├── Init VideoPlayerController
│   ├── Set timeout (15s untuk <50MB, 30s untuk >50MB)
│   ├── Tunggu video selesai (onVideoEnd listener)
│   └── Panggil _onAssetComplete()
│
└── JIKA IMAGE:
    ├── Cek resolusi ≤ 2560×1440
    ├── Decode & tampilkan gambar
    ├── Tunggu display duration (dari DB)
    └── Panggil _onAssetComplete()
```

#### \_onAssetComplete() — Titik Kritis

```
_onAssetComplete()
├── Cek face status via FaceTrackingService:
│
├── KASUS 1: New face appeared
│   ├── ImpressionTracker.endPlayback() → simpan data
│   ├── FaceTrackingService.resetTracking()
│   ├── Pindah ke state SCANNING
│   └── Mulai deteksi wajah baru
│
├── KASUS 2: All faces disappeared
│   ├── ImpressionTracker.endPlayback() → simpan data
│   ├── Kembali ke Default Playback
│   └── Reset state ke SCANNING
│
└── KASUS 3: Same face continues
    ├── Lanjut ke asset berikutnya dalam playlist
    ├── playNext()
    └── Jika sudah di asset terakhir → endPlayback(), kembali ke Default
```

---

### 4.8 Face Tracking & Impression

**File:** `lib/services/face_tracking_service.dart` dan `lib/services/impression_tracker.dart`

#### Face Tracking

```
FaceTrackingService.trackFaces(faces)
├── Untuk setiap wajah yang terdeteksi:
│   ├── resolveFaceId(face):
│   │   ├── Gunakan MLKit trackingId jika tersedia
│   │   └── Jika tidak: estimasi dari posisi bounding box
│   └── Update lastSeenTime
│
├── hasNewFaceAppeared():
│   └── Ada face ID baru yang belum pernah terlihat?
│
└── haveAllFacesDisappeared():
    └── Semua face terakhir sudah > 3 detik tidak terlihat?
```

**Cleanup timer tiap 1 detik:**

```
cleanupTimer → FaceTrackingService.cleanup()
└── Hapus face ID yang tidak terlihat > 3 detik
```

#### Impression Tracking

```
ImpressionTracker lifecycle:
│
├── startPlayback(campaignId, assetId, playlistId)
│   └── Buat record impression baru
│
├── onFaceDetected(faceId)               ← dipanggil tiap frame ada wajah
│   └── Update lastSeenTime untuk faceId
│
├── seedAudience(faceId, age, gender)    ← setelah deteksi selesai
│   └── Tambah atribut demografi ke face
│
├── onDetectionComplete(gender, age)
│   └── Update targeting info di impression
│
└── endPlayback()
    ├── Hitung durasi tiap wajah (endTime - startTime)
    ├── Filter: hanya simpan wajah yang dilihat ≥ 2 detik
    ├── Map gender/age ke ID di database
    ├── Simpan ke SQLite: impressions + audience records
    └── Hapus record kosong
```

---

### 4.9 Error Handling & SUPERFK State

**File:** `lib/view/video/controllers/playback_controller.dart`

```
_handleAssetError(asset, error)
├── Catat asset sebagai corrupted
│
├── Hitung error rate:
│   └── errorCount / totalAssetsInPlaylist
│
├── ATURAN Default Assets:
│   ├── 1 error dari 1 asset    → SUPERFK (100%)
│   ├── 1 error dari 2 assets   → SUPERFK (50%)
│   └── 2+ error dari 3+ assets → SUPERFK (≥66%)
│
├── ATURAN Targeted Assets:
│   ├── 1 asset gagal → skip, tandai campaign invalid
│   └── 2+ error dari 2+ assets (50%) → SUPERFK
│
└── Jika threshold tercapai → _enterSuperfkState()
```

#### SUPERFK State

```
_enterSuperfkState()
├── Set flag _isSuperfkState = true
├── Stop semua deteksi
├── Stop camera stream
├── Tampilkan error screen
└── Blokir semua operasi playback

exitSuperfkState()          ← harus dipanggil manual
├── Clear corrupted assets list
├── Reset error counters
├── Set _isSuperfkState = false
└── Reload assets & restart
```

---

### 4.10 Cleanup & Dispose

**Fungsi:** `dispose()` di `DetectionVideoPlayerPageState`

```
dispose()
├── PlaybackTimerManager.cancelAll()     → stop semua timer
├── FaceDetector.close()                 → release MLKit
├── OnnxService.dispose()                → release ONNX session
├── CameraController.dispose()           → release kamera
├── PlaybackController.dispose()         → dispose video player
├── ImpressionTracker.dispose()          → simpan data yang pending
└── WidgetsBinding.removeObserver(this)  → unregister lifecycle observer
```

**App Lifecycle Handling** (`didChangeAppLifecycleState`):

```
paused/inactive → hentikan kamera & playback
resumed         → reinit kamera & restart playback
detached        → full dispose
```

---

## 5. Diagram Alur

```
KAMERA FRAME
     │
     ▼
┌─────────────────────────────────────┐
│  MLKit Face Detection               │
│  - Deteksi semua wajah              │
│  - Track face ID                    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Face Filter (FaceDetectionUtils)   │
│  - Pilih wajah terbesar             │
│  - Validasi ukuran (≥20%)           │
│  - Validasi sudut (±25°)            │
└──────────────┬──────────────────────┘
               │ readyToProcess
               ▼
┌─────────────────────────────────────┐
│  ONNX Inference (OnnxService)       │
│  - Crop face/person                 │
│  - Resize 384×384 + normalize       │
│  - Predict: gender + age            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Consensus (PredictionConsensus)    │
│  - Kumpulkan N sampel               │
│  - Median age, majority gender      │
└──────────────┬──────────────────────┘
               │ consensus locked
               ▼
┌─────────────────────────────────────┐
│  Asset Matching (VisualAssetDb)     │
│  - Query: gender + age_group → DB   │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
  MATCH FOUND     NO MATCH
       │               │
       ▼               ▼
┌──────────────┐  ┌──────────────────┐
│  Targeted    │  │  Default         │
│  Playback    │  │  Playback        │
│  (Campaign   │  │  (loop default   │
│   assets)    │  │   assets)        │
└──────┬───────┘  └──────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Asset Complete?                    │
│  - New face? → restart detection    │
│  - Face lost? → default playback    │
│  - Same face? → next asset          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Impression Tracker                 │
│  - Rekam durasi lihat per wajah     │
│  - Simpan audience data ke SQLite   │
└─────────────────────────────────────┘
```

---

## 6. Detail Fungsi Per File

### `detection_video_player_page.dart` — Fungsi Utama

| Fungsi                      | Deskripsi                                                |
| --------------------------- | -------------------------------------------------------- |
| `_initialize()`             | Bootstrap seluruh sistem (model, kamera, DB, tracker)    |
| `_processImage()`           | Entry point tiap frame kamera                            |
| `_runOnnxInference()`       | Jalankan prediksi AI, dengan gate untuk sparse inference |
| `_onDetectionComplete()`    | Handler setelah consensus selesai                        |
| `_processDetectionResult()` | Query DB & trigger targeted playback                     |
| `_onAssetComplete()`        | Cek status wajah setelah tiap aset selesai               |
| `_handleNewFaceDetected()`  | Wajah baru muncul → restart deteksi                      |
| `_handleFaceLost()`         | Semua wajah hilang → kembali ke default                  |
| `_handleSameFaceContinue()` | Wajah sama → lanjut aset berikutnya                      |

### `onnx_service.dart` — Fungsi Utama

| Fungsi                    | Deskripsi                                   |
| ------------------------- | ------------------------------------------- |
| `loadModel()`             | Init ONNX session (ResNet18 / FastViT)      |
| `predict(image)`          | Preprocess + inference + parse output       |
| `_preprocessImage()`      | Resize 384×384 + ImageNet normalization     |
| `_parseOutputsResNet18()` | Parse: gender softmax (2-class) + age       |
| `_parseOutputsFastViT()`  | Parse: age_multiplier (0-1) + gender logits |

### `playback_controller.dart` — Fungsi Utama

| Fungsi                       | Deskripsi                                    |
| ---------------------------- | -------------------------------------------- |
| `loadDefaultAssets()`        | Load fallback playlist dari DB               |
| `switchToTargetedPlayback()` | Ganti playlist ke campaign assets            |
| `switchToDefaultPlayback()`  | Kembali ke default playlist                  |
| `playAsset()`                | Putar satu aset (video atau image)           |
| `playNext()`                 | Lanjut ke aset berikutnya dalam playlist     |
| `_playVideoOptimized()`      | Load video dengan validasi lengkap + timeout |
| `_showImage()`               | Tampilkan gambar dengan durasi dari DB       |
| `_handleAssetError()`        | Routing error ke counter/SUPERFK logic       |
| `_enterSuperfkState()`       | Masuk critical error state                   |
| `exitSuperfkState()`         | Keluar dari critical error state             |

---

> **Catatan:** Sparse inference selama `playingTargeted` berjalan setiap **5 detik** untuk mendeteksi apakah ada wajah baru yang tidak dikenal masuk ke frame, tanpa menginterupsi playback campaign yang sedang berjalan.
