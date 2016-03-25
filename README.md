# Scilab-functions
This repo contains the functions written in Scilab to replicate their equivalent in MATLAB for the purpose of FOSSEE internship evaluation.

Functions and their exhaustive description are given below:

1. ismaxphase
    Checks whether the polynomial specified by 'b' has all its roots outside unit circle or not. If all roots strictly outside unit circle then 'f' is T else 'f' is F.
    
    INPUT:numerator vector of digital filter i.e.b, denominator vector of digital filter i.e. a (optional), tolerance to specify whether two numbers are close enough i.e. tol (optional). Input can also be SOS(second order sections) matrix having exactly 6 columns and N number of rows.
    
    OUTPUT: boolean variable T or F. T specifies filter given as input is maximum phase and F specifies filter given as input is minimum phase
    
    DESCRIPTION:
    flag=ismaxphase(b,a) returns a logical output equal to true if filter H(z)=B(z)/A(z) is maximum phase
    
    flag=ismaxphase(sos) returns a logical output equal to true if filter specified by the SOS matrix 'sos', is maximum phase else logical output is false.
    
    flag=(...,tol) uses 'tol' to specify tolerance that whether two numbers can be considered close enough.If not specified then default value of eps^(2/3) is assumed for 'tol'.
    
    EXAMPLES:
    
    flag=ismaxphase([1 2 3])
    
    flag=ismaxphase([1 2 3 4 5 6;4 5 7 8 9 2])
    
    flag=ismaxphase([1 2],[3 4 5],0.1)
    
    SOURCES: 
    MATLAB, MATLAB help

2. ca2tf
    Convert coupled allpass filter to transfer function form
    
    INPUT:denominator of the allpass filter H1(z) i.e. d1, denominator of the allpass filter H2(z) i.e. d2, a factor Beta (optional)
    
    OUTPUT:
    b:vector of coefficients corresponding to the numerator of the transfer function
    a:vector of coefficients corresponding to the denominator of the transfer function where the filter H(z)=B(z)/A(z)
    
    bp:vector of coefficients corresponding to the numerator of the power complementary filter G(z) where G(z)=Bp(z)/A(z) and we have:
     |H(z)|^2+|G(z)|^2=1
    
    DESCRIPTION:
    
    [b,a,bp]=ca2tf(d1,d2) where d1 and d2 are real vectors, returns b, a and bp where
    H(z)=B(z)/A(z)=(1/2)*[H1(z)+H2(z)]
    G(z)=Bp(z)/A(z)=(1/2)*[H2(z)-H1(z)]
    
    [b,a,bp]=ca2tf(d1,d2,Beta) where d1, d2 and Beta are complex, returns b,a and bp where
    H(z)=B(z)/A(z)=(1/2)*[conj(Beta)*H1(z)+Beta*H2(z)]
    G(z)=Bp(z)/A(z)=(-1/2j)*[-conj(Beta)*H1(z)+Beta*H2(z)]
    
    EXAMPLES:
    
    b=ca2tf([1 2],[2 3])
    
    b=ca2tf(1+%i,1+2*%i,%i)
    
    [b a bp]=ca2tf([1 2],[3 4 5],0.1)
    
    SOURCES: 
    MATLAB, MATLAB help
    

3. iirnotch
     Designs a second order IIR notch filter
    
    INPUT:
    Wo: normalized frequency which specifies the location of the notch
    BW: normally, the -3dB bandwidth, where the quality factor q=Wo/BW.
    Ab:optional, if given then BW is specified at -Ab dB, if not given then default value of 3dB assumed.
    
    OUTPUT:
    num: numerator of the second order notch filter
    den:denominator of the second order notch filter
    
    DESCRIPTION:
    
    [num,den]=iirnotch(Wo,BW) returns a notch filter having notch at 'Wo' and having bandwidth at -3dB equal to 'BW'.'Wo' and 'BW' should be between 0 and 1.
    
    [num,den]=iirnotch(Wo,BW,Ab) returns a notch filter having notch at 'Wo' and having bandwidth at -'Ab' dB equal to 'BW'. 'Ab' need'nt be 3dB, but 'Wo' and 'BW' should be between 0 and 1.
    
    EXAMPLES:
    
    [num,den]=iirnotch(0.2,0.3)
    
    [num,den]=iirnotch(0.2,0.3,6)
    
    SOURCES: 
    MATLAB, MATLAB help, The Digital All-Pass Filter: A Versatile Signal Processing Building Block by Regalia, Mitra and Vaidynathan, Introduction to Signal Processing by Sophocles Orfanidis.

AUTHOR:
Nagma Samreen Khan.
