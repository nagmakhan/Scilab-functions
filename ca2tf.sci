function [b,a,bp]=ca2tf(d1,d2,Beta)
    //ca2tf Convert coupled allpass filter to transfer function form
    //
    //INPUT:denominator of the allpass filter H1(z) i.e. d1, denominator of the allpass filter H2(z) i.e. d2, a factor Beta (optional)
    //
    //OUTPUT:
    //b:vector of coefficients corresponding to the numerator of the transfer function
    //a:vector of coefficients corresponding to the denominator of the transfer function where the filter H(z)=B(z)/A(z)
    //
    //bp:vector of coefficients corresponding to the numerator of the power complementary filter G(z) where G(z)=Bp(z)/A(z) and we have:
    // |H(z)|^2+|G(z)|^2=1
    //
    //DESCRIPTION:
    //
    //[b,a,bp]=ca2tf(d1,d2) where d1 and d2 are real vectors, returns b, a and bp where
    //H(z)=B(z)/A(z)=(1/2)*[H1(z)+H2(z)]
    //G(z)=Bp(z)/A(z)=(1/2)*[H2(z)-H1(z)]
    //
    //[b,a,bp]=ca2tf(d1,d2,Beta) where d1, d2 and Beta are complex, returns b,a and bp where
    //H(z)=B(z)/A(z)=(1/2)*[conj(Beta)*H1(z)+Beta*H2(z)]
    //G(z)=Bp(z)/A(z)=(-1/2j)*[-conj(Beta)*H1(z)+Beta*H2(z)]
    //
    //EXAMPLES:
    //
    //b=ca2tf([1 2],[2 3])
    //
    //b=ca2tf(1+%i,1+2*%i,%i)
    //
    //[b a bp]=ca2tf([1 2],[3 4 5],0.1)
    //
    //AUTHOR:Nagma Samreen Khan
    //
    //SOURCES: MATLAB, MATLAB help
    
    
    //Checking for appropriate number of inputs and displaying a proper error message otherwise
    if argn(2)<2 then
        disp("ERROR:Too few input arguments");
        abort
    elseif argn(2)>3 then
        disp("ERROR:Too many input arguments");
        abort
    end
    
    if argn(2)==2 then
        Beta=1; //Assuming Beta to be one
    end
    
    //Checking whether any of the inputs is imaginary
//    if isReal & or(~real(d1) | ~real(d2)) then
//        d1=real(d1);
//        d2=real(d2);
//    end
    
    //Making d1 and d2 row vectors
    d1=d1(:).';
    d2=d2(:).';
    
    //Construct the numerator from the denominator
    d1_num=conj(d1($:-1:1));
    d2_num=conj(d2($:-1:1));
    
    //Calculating the denominator
    a=conv(d1,d2);
    
    //Calculating numerator 'b'
    b=(1/2)*((conj(Beta)*conv(d1_num,d2))+(Beta*conv(d2_num,d1))); 
    
    //Calculating power complementary filters numerator 'bp'
    //Handling real and imaginary cases separately
    if isreal(d1)&isreal(d2)&(norm(Beta-1,%inf)<(10^(-11))) then
       bp=(-1/2)*(conv(d1_num,d2)-conv(d2_num,d1));
   else
       bp=(-1/2*%i)*((conv((-conj(Beta)*d1_num),d2))+(conv((Beta*d2_num),d1)));
    end
    
    if isreal(bp) then
        bp=bp($:-1:1);
    end
    
    //pruning the very small imaginary parts
    a=pruneimag(a);
    b=pruneimag(b)
    bp=pruneimag(bp);
endfunction

function prunepoly=pruneimag(prunepoly,tol)
    if argn(2)<2 then
        tol=10^-11;
    end
    
    if max(abs(imag(prunepoly)))<tol then
        prunepoly=real(prunepoly);
    end
endfunction
