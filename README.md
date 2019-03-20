# Coarse-grained-anisotropy-and-size-using-FFT

This folder contains all the codes needed to perform the analysis developed and described in the article: 
    Fast determination of cell anisotropy and size in epithelial tissue images using Fourier Transform

Abstract of the article:

Mechanical strain and stress play a major role in biological processes such as wound healing or
morphogenesis. To assess this role quantitatively, fixed or live images of tissues are acquired at a
cellular precision in large fields of views. To exploit these data, large number of cells have to be
analyzed to extract cell shape anisotropy and cell size. Most frequently, this is performed through
detailed individual cell contour determination, using so-called segmentation computer programs,
complemented if necessary by manual detection and error corrections. However, a coarse grained and
faster technique can be recommended in at least three situations. First, when detailed information
on individual cell contours is not required, for instance in studies which require only coarse-grained
average information on cell anisotropy. Second, as an exploratory step to determine whether full
segmentation can be potentially useful. Third, when segmentation is too difficult, for instance due to
poor image quality or a too large cell number. We developed a user-friendly, Fourier Transform based
image analysis pipeline. It is fast (typically 104 cells per minute with a current laptop computer) and
suitable for time, space or ensemble averages. We validate it on one set of artificial images and on
two sets of fully segmented images, from Drosophila pupa and chicken embryo; the pipeline results
are robust. Perspectives include in vitro tissues, non-biological cellular patterns such as foams, and
xyz stacks.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development.

### Prerequisites

You will need a version of matlab older than 2015. 
Images should be either .png or .tiff .tif (stacks are okay)

### Installing

To use the code you will need to download the whole repository. Then in matlab, navigate in the "browse folder section" and enter the folder coarse-grained-anisotropy-and-size-using-FFT. This folder contains one main script that you will need to change, and one sub-folder containing all the codes that you will not need to change to make it work. 

Once you are there, double click on the script called "main script".


### How to use it in practice

In this main code, you can set and see the main parameters of the program. The parameters that you should change each time are the ones regarding the location of your data on your computer and the location of the output folder you will have. 

```
Param.name = {'/Users/Melina/Desktop/Nicolas/'};

```
Param.name should always be written this way. Be careful of the brakets and the slash at the end. It should be the path to your images.

```
Param.pathin = {'/Users/Melina/Desktop/Nicolas/'};

```
Param.pathin should always be written this way. Be careful of the brakets and the slash at the end. It should be the path to the folder where you want the program to create the output folder. Here, the output folder will be created at the same location of your images. 

```
Param.rec = 0.5;                % Overlap between boxes   
Param.tsart = 10;                % Begining of the analysis
Param.tleng = 27;                % End of the analysis
Param.timestep = 2;             % Time step on which to time average

```

These are the only parameters that you NEED to change if you don't know/like coding.In this example, the overlap between the boxes will be of 50%, the first timeframe analysed will be the 10th image, the last one will be the 27 th and the sliding averaged will be of 2, so you will get 16 analysed frames corresponding to the average of frame 1 and 2, 2 and 3 and so on. 

You can then press the run button on the top of your screen.

### What the parameters are 

In this main code, you can set and see the main parameters of the program. 


```
Param.pas2= 100;                % Size of the subwindows
Param.cut = 5;                  % Number of pixels to cut around the center of the spectrum so as to visualize better
Param.propor =  0.02;           % Proportion of points to keep for the thresholded spectrum
Param.sigma = 0.8;              % Gaussian filter
Param.register = 0;             % 1 to save the spectrums (be careful it's heavy) 0 otherwise
Param.regsize = 0;              % Analysis in size
Param.nbpoints = 30;            % Nmber of points to keep 
Param.strel = 4;                % Parameter to fill the holes in the thresholded spectrum

```

### If you spot problems, email me please :-) !
  
