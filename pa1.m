clear
close all

% name of the input file
imname = 'harvesters.png';


% read in the image
fullim = imread(fullfile('sample_images',imname));

% convert to double matrix
% this conversion also scales intensities in each channel to [0,1] range
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);

% separate color channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

% create a color image (3D array)
rgbNotAligned(:,:,1) = R;
rgbNotAligned(:,:,2) = G;
rgbNotAligned(:,:,3) = B;
imshow(rgbNotAligned);

% TO BE DONE: Align the channels using SSD metric
R_ = align(G,R);
B_ = align(G,B);
AlignedImage = cat(3,R_,G,B_);
imshow(AlignedImage);
%saveas(gcf,imname+"aligned_image.png");


% TO BE DONE: Apply gamma transform

% Gamma Values for first try 0.8 for all channels
% Gamma Values for first try 1.5 for all channels
% Gamma Values for third try  0.8, 0.7, 0.6 channels
% Gamma Values for fourth try 1.5, 1.2, 1.5 channels

gammaRED = myGammaTransform(R_,0.8);
gammaBLUE = myGammaTransform(B_,0.8);
gammaGREEN = myGammaTransform(G,0.8);

rgbAligned(:,:,1) = gammaRED;
rgbAligned(:,:,2) = gammaGREEN;
rgbAligned(:,:,3) = gammaBLUE;

figure;imshow(rgbAligned);

%saveas(gcf,imname+"gamma_applied_1.png");


% TO BE DONE: Apply histogram equalization after converting Lab color space
lab = rgb2lab(rgbAligned);
L = lab(:,:,1)./100;
L_ = histeq(L).*100;
Lab_(:,:,1) = L_;
Lab_(:,:,2) = lab(:,:,2);
Lab_(:,:,3) = lab(:,:,3);
Result_Image = lab2rgb(Lab_);
figure;imshow(Result_Image);
%saveas(gcf,imname+"hist_eq_applied.png");

function RGB_aligned = align(green,red)

    MiN = 10000000000;
    [RED_row,RED_column] = size(red);
    [GREEN_row,GREEN_column] = size(green);    

    RED = red(ceil((RED_row-50)/2) : ceil((RED_row-50)/2) + 50,ceil((RED_column-50)/2) :ceil((RED_column-50)/2) + 50);
    GREEN = green(ceil((GREEN_row-50)/2) : ceil((GREEN_row-50)/2) + 50,ceil((GREEN_column-50)/2) :ceil((GREEN_column-50)/2) + 50);
    
    index = 0;
    dim = 1;
   
    for i = -15:15
        for j = 1:2
            score = mySSD(GREEN,circshift(RED,i,j));
            if score < MiN
                MiN = score;
                index = i;
                dim = j;
            end
        end
    end
    RGB_aligned = circshift(red,index,dim);
end       

