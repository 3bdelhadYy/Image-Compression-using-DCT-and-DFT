# Image Compression using DCT and DFT

A MATLAB implementation of block-based image compression using the Discrete Cosine Transform (DCT) and Discrete Fourier Transform (DFT). The project investigates the effect of coefficient retention and block size on reconstruction quality and compares the performance of DCT and DFT using Mean Squared Error (MSE).

## Overview

Image compression is achieved by transforming image blocks into the frequency domain, retaining only the most significant coefficients, and reconstructing the image using inverse transforms.

The project compares:

- 2D Discrete Cosine Transform (DCT)
- 2D Discrete Fourier Transform (DFT)
- Different block sizes
- Different coefficient retention ratios
- Reconstruction quality using MSE

## Features

- Custom implementation of:
  - 2D DFT / IDFT
  - 2D DCT / IDCT
- Magnitude-based coefficient reduction
- Block-based image processing
- Quantitative comparison using MSE
- Visual comparison of reconstructed images
- Performance evaluation across multiple compression levels

## Experimental Setup

### Block Sizes

```text
4×4
8×8
16×16
32×32
64×64
128×128
256×256
```

### Retention Ratios

```text
10%
25%
50%
75%
100%
```

### Test Image

```text
cameraman.tif
256 × 256 grayscale image
```

## Compression Pipeline

```text
Input Image
      │
      ▼
Split into Blocks
      │
      ▼
DCT / DFT
      │
      ▼
Coefficient Reduction
      │
      ▼
IDCT / IDFT
      │
      ▼
Reconstructed Image
      │
      ▼
MSE Evaluation
```

## Results

### MSE vs Retention Ratio

As the retention ratio increases:

- More frequency coefficients are preserved
- Reconstruction quality improves
- MSE decreases significantly

Example result:

| Retention Ratio | DCT MSE (8×8) | DFT MSE (8×8) |
|---------------|--------------|--------------|
| 0.10 | 3.58e-4 | 7.40e-4 |
| 0.25 | 8.36e-5 | 2.43e-4 |
| 0.50 | 1.54e-5 | 6.26e-5 |
| 0.75 | 1.70e-6 | 1.17e-5 |
| 1.00 | ~0 | ~0 |

### Key Findings

- DCT consistently achieves lower MSE than DFT.
- Larger block sizes generally improve reconstruction quality.
- Higher retention ratios preserve more image details.
- DCT provides better energy compaction and compression efficiency.

## Visual Comparison

### Effect of Block Size

| Original | DCT Reconstruction | DFT Reconstruction |
|----------|-------------------|-------------------|
| Various block sizes from 4×4 to 256×256 were evaluated |

### Effect of Retention Ratio

| Retention | Observation |
|-----------|------------|
| 10% | Highest compression, visible quality loss |
| 25% | Good balance |
| 50% | High visual quality |
| 75% | Nearly identical to original |
| 100% | Perfect reconstruction |

## Technologies Used

- MATLAB
- Digital Signal Processing
- Image Processing
- DCT
- DFT

## Repository Structure

```text
.
├── project_source_code.m
├── mse_data.xlsx
├── Saved_Results/
│   ├── Reconstructed Images
│   ├── Comparison Figures
│   └── MSE Plots
├── CIE_442_project_1_Report.pdf
└── README.md
```

## How to Run

1. Open MATLAB.
2. Load `project_source_code.m`.
3. Run the script.
4. Generated images and plots will be saved automatically.

## Authors

- Abdelhady Mohamed
- Osama Mohamed

## Course

CIE 442 – Digital Signal Processing  
Zewail City of Science and Technology
