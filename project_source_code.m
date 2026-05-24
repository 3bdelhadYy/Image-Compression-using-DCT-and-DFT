clear; close all; clc;

%% prepare the image

%img = imread('test1.jpg');
img = imread('cameraman.tif');

if ndims(img) == 3
    img = rgb2gray(img);
end

img = imresize(img , [256 256]);
img = im2double(img); 
%% Main code

block_sizes = [4, 8, 16, 32, 64, 128, 256];
retention_ratios = [0.10, 0.25, 0.50, 0.75, 1];

MSE_DCT_results = zeros(numel(block_sizes), numel(retention_ratios));
MSE_DFT_results = zeros(numel(block_sizes), numel(retention_ratios));

[R, C] = size(img);

for bs = 1:numel(block_sizes)
    block_size = block_sizes(bs);
    fprintf('Running block size = %d\n', block_size);

    for rr = 1:numel(retention_ratios)
        retention_ratio = retention_ratios(rr);
        fprintf('retention = %.2f', retention_ratio);

        Reconstructed_DFT = zeros(R,C);
        Reconstructed_DCT = zeros(R,C);

        for r = 1:block_size:R
            for c = 1:block_size:C
                block = img(r:r+block_size-1, c:c+block_size-1);

                % DCT
                out_dct = DCT_2D(block);
                out_dct = Coefficient_Reduction(out_dct, retention_ratio);
                out_idct = IDCT_2D(out_dct);
                Reconstructed_DCT(r:r+block_size-1, c:c+block_size-1) = out_idct;

                % DFT
                out_dft = DFT_2D(block);
                out_dft = Coefficient_Reduction(out_dft, retention_ratio);
                out_idft = IDFT_2D(out_dft);
                out_idft = real(out_idft);
                Reconstructed_DFT(r:r+block_size-1, c:c+block_size-1) = out_idft;
            end
        end
        
        % figure;
        % 
        % subplot(1,2,1);
        % imshow(Reconstructed_DFT);
        % title(sprintf('DFT | Block = %d | Retention = %.2f', block_size, retention_ratio));
        % 
        % subplot(1,2,2);
        % imshow(Reconstructed_DCT);
        % title(sprintf('DCT | Block = %d | Retention = %.2f', block_size, retention_ratio));



        mse_dct = mean((img - Reconstructed_DCT).^2, 'all');
        mse_dft = mean((img - Reconstructed_DFT).^2, 'all');

        MSE_DCT_results(bs, rr) = mse_dct;
        MSE_DFT_results(bs, rr) = mse_dft;

        compression_ratio = 1 / retention_ratio;
        fprintf('     Compression Ratio = %.2f : 1\n', compression_ratio);


    end
end

%% Print results
fprintf('\nFinal MSE table (rows: block sizes %s ; cols: retention ratios %s)\n', mat2str(block_sizes), mat2str(retention_ratios));
fprintf('DCT MSEs:\n'); disp(MSE_DCT_results);
fprintf('DFT MSEs:\n'); disp(MSE_DFT_results);

%% MSE vs retention ratio 
figure('Name','MSE vs Retention Ratio','NumberTitle','off');

base_markers = {'o','s','^','d','x','+','v','p','h','<','>'}; % many shapes
nBS = numel(block_sizes);
if nBS > numel(base_markers)
    base_markers = repmat(base_markers, 1, ceil(nBS/numel(base_markers)));
end

solid_markers  = strcat('-', base_markers(1:nBS));
dashed_markers = strcat(':', base_markers(1:nBS));
colors = lines(nBS);    

hold on;
for bi = 1:nBS

    plot(retention_ratios, MSE_DCT_results(bi,:), solid_markers{bi}, ...
        'LineWidth', 1.6, 'Color', colors(bi,:), 'MarkerSize',6);

    plot(retention_ratios, MSE_DFT_results(bi,:), dashed_markers{bi}, ...
        'LineWidth', 1.4, 'Color', colors(bi,:), 'MarkerSize',6);
end
hold off;

xlabel('Retention ratio');
ylabel('MSE (lower is better)');
title('MSE vs retention ratio solid = DCT, dashed = DFT');

legendEntries = cell(1, 2*nBS);
for bi = 1:nBS
    legendEntries{2*bi-1} = sprintf('DCT %dx%d', block_sizes(bi), block_sizes(bi));
    legendEntries{2*bi}   = sprintf('DFT %dx%d', block_sizes(bi), block_sizes(bi));
end
legend(legendEntries, 'Location', 'northeastoutside', 'FontSize', 9);
grid on;
set(gcf,'Color','w');


%% Helper Function
%% 2D-DFT
function F = DFT_2D(Img)
% Matrix-multiply 2D DFT (fast)
[N1, N2] = size(Img);
n1 = 0:N1-1; m1 = n1.';
n2 = 0:N2-1; m2 = n2.';

W1 = exp(-1i*2*pi*(m1 * n1) / N1);    % size N1 x N1
W2 = exp(-1i*2*pi*(m2 * n2) / N2);    % size N2 x N2

% 2D DFT as two matrix multiplies
F = W1 * Img * (W2)';
end

%% 2D-IDFT
function Img_rec = IDFT_2D(F)

[N1, N2] = size(F);
n1 = 0:N1-1; m1 = n1.';
n2 = 0:N2-1; m2 = n2.';

W1 = exp(-1i*2*pi*(m1 * n1) / N1);
W2 = exp(-1i*2*pi*(m2 * n2) / N2);

Img_rec = (W1' * F * (W2)) / (N1 * N2);
end

%% 2D-DCT
function D = DCT_2D(Img)

Img = double(Img);
[N1, N2] = size(Img);

C1 = dct_matrix(N1);
C2 = dct_matrix(N2);

D = C1 * Img * C2.';
end

%% 2D-IDCT
function Img_rec = IDCT_2D(D)

[N1, N2] = size(D);

C1 = dct_matrix(N1);
C2 = dct_matrix(N2);

Img_rec = C1.' * D * C2;
end

%% Helper function to DCT & IDCT
function C = dct_matrix(N)

alpha = sqrt(1/N) * ones(N,1);
alpha(2:end) = sqrt(2/N);
n = 0:N-1;
C = zeros(N,N);
for k = 0:N-1
    C(k+1, :) = alpha(k+1) * cos( pi*(2*n+1)*k / (2*N) );
end
end

%% Coefficient reduction
function reduction_out = Coefficient_Reduction(reduction_in, retention_ratio)

if retention_ratio >= 1
    reduction_out = reduction_in;
    return;
end

vec = abs(reduction_in(:));
num_to_keep = max(1, round(retention_ratio * numel(vec)));

if num_to_keep == numel(vec)
    reduction_out = reduction_in;
    return;
end

sorted_vec = sort(vec, 'descend');
keeped = sorted_vec(num_to_keep);
reduction_out = reduction_in .* (abs(reduction_in) >= keeped);   
end



