function [num,den]=iirnotch(Wo,BW,varargin)
    //iirnotch Designs a second order IIR notch filter
    //
    //INPUT:
    //Wo: normalized frequency which specifies the location of the notch
    //BW: normally, the -3dB bandwidth, where the quality factor q=Wo/BW.
    //Ab:optional, if given then BW is specified at -Ab dB, if not given then default value of 3dB assumed.
    //
    //OUTPUT:
    //num: numerator of the second order notch filter
    //den:denominator of the second order notch filter
    //
    //DESCRIPTION:
    //
    //[num,den]=iirnotch(Wo,BW) returns a notch filter having notch at 'Wo' and having bandwidth at -3dB equal to 'BW'.'Wo' and 'BW' should be between 0 and 1.
    //
    //[num,den]=iirnotch(Wo,BW,Ab) returns a notch filter having notch at 'Wo' and having bandwidth at -'Ab' dB equal to 'BW'. 'Ab' need'nt be 3dB, but 'Wo' and 'BW' should be between 0 and 1.
    //
    //EXAMPLES:
    //
    //[num,den]=iirnotch(0.2,0.3)
    //
    //[num,den]=iirnotch(0.2,0.3,6)
    //
    //AUTHOR:Nagma Samreen Khan
    //
    //SOURCES: MATLAB, MATLAB help, The Digital All-Pass Filter: A Versatile Signal Processing Building Block by Regalia, Mitra and Vaidynathan, Introduction to Signal Processing by Sophocles Orfanidis
    
    
    //Checking for appropriate number of inputs and displaying a proper error message otherwise
    if argn(2)<2 then
        disp("ERROR:Too few input arguments");
        abort
    elseif argn(2)>3 then
        disp("ERROR:Too many input arguments");
        abort
    end
    
    //Validate inputs
    if Wo<=0 | Wo>=1 then
        disp("ERROR:The frequency Wo should be between 0 and 1");
        abort
    end
    
    if BW<=0 | BW>=1 then
        disp("ERROR:The bandwidth BW should be between 0 and 1");
        abort
    end
    
    //If Ab is not specified then set it to default value of 3dB
    if ~isempty(varargin) then
        Ab=varargin(1);
    else
        Ab=3;
    end
    
    //Converting Wo and BW from normalized form
    Wo=Wo*(%pi);
    BW=BW*(%pi);
    
    //Finding 2nd order notch filter
    if  Ab==3 then
         k1=-cos(Wo);
         k2=(1-tan(BW/2))/(1+tan(BW/2));
         den=[1 k1*(1+k2) k2];
         num=(1/2)*[(1+k2) 2*k1*(1+k2) (1+k2)];
     else
         //For non -3dB case
         Gb=(10^(-Ab/20));
         b=1/(1+(tan(BW/2)*sqrt(1-Gb^2)/Gb));
         num=b*[1 -2*cos(Wo) 1];
         den=[1 -2*b*cos(Wo) (2*b-1)];
    end

endfunction
