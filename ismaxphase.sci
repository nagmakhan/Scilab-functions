function f=ismaxphase(b,varargin)
    //ismaxphase Check whether the polynomial specified by 'b' has all its roots outside unit circle or not. If all roots strictly outside unit circle then 'f' is T else 'f' is F.
    //
    //INPUT:numerator vector of digital filter i.e.b, denominator vector of digital filter i.e. a (optional), tolerance to specify whether two numbers are close enough i.e. tol (optional). Input can also be SOS(second order sections) matrix having exactly 6 columns and N number of rows.
    //
    //OUTPUT: boolean variable T or F. T specifies filter given as input is maximum phase and F specifies filter given as input is minimum phase
    //
    //DESCRIPTION:
    //flag=ismaxphase(b,a) returns a logical output equal to true if filter H(z)=B(z)/A(z) is maximum phase
    //
    //flag=ismaxphase(sos) returns a logical output equal to true if filter specified by the SOS matrix 'sos', is maximum phase else logical output is false.
    //
    //flag=(...,tol) uses 'tol' to specify tolerance that whether two numbers can be considered close enough.If not specified then default value of eps^(2/3) is assumed for 'tol'.
    //
    //EXAMPLES:
    //
    //flag=ismaxphase([1 2 3])
    //
    //flag=ismaxphase([1 2 3 4 5 6;4 5 7 8 9 2])
    //
    //flag=ismaxphase([1 2],[3 4 5],0.1)
    //
    //AUTHOR:Nagma Samreen Khan
    //
    //SOURCES: MATLAB, MATLAB help
    
    rhs=argn(2); //Get the no of input arguments
    //Checking for correct no of input arguments,if less than one or more than 
    //3 then display error
    if rhs<1 then
        disp("ERROR:Too few input arguments")
        abort
    elseif rhs>3 then
        disp("ERROR:Too many input arguments")
        abort
    end
    
    a=1; //Assume FIR for now
    isTF=1; //Assume input is a transfer function
    
    if and(size(b)>[1 1]) then
        //If input is a matrix, check if it is a valid SOS matrix i.e. has exactly 6 columns
        if size(b,2)~=6 then
            disp("ERROR:When first input is a matrix, it must have exactly 6 columns to be a valid SOS matrix");
            abort
        end
         
         isTF=0; //Input is valid SOS matrix(has exactly 6 columns) and not transfer function
         
     elseif ~isempty(varargin)
         a=varargin(1);
         if and(size(a)>[1 1]) then
             disp("ERROR:Both numerator and denominator of the transfer function have to be vector");
             abort
         end
         varargin(1)=[];
    end
    
    if isempty(varargin) then
        tol=[];
    else
        tol=varargin(1);
    end
    
    if isTF then
        f=checkmaxphase(b,a,tol);
    else
        //If SOS matrix then check section by section where num(i)=b(i,1:3) and den(i)=b(i,4:6) for each ith section
        f=%T;
        for indx=1:size(b,1)
        f=f & checkmaxphase(b(indx,1:3),b(indx,4:6),tol);
        end
    end
endfunction

function flag=isStable(a,tol)
    //isStable To test if all roots of the polynomial are inside unit circle or not. It gives a logical output 'flag', 'flag' will be 1 if all roots are strictly insdie unit circle else 'flag' will be zero.'tol' specifies the tolerance to determine when two numbers are close enough to be considered equal. If not specified then default value of 0 is assumed for 'tol'. 
    
    if argn(2)<2 then
        tol=[];
    end
    
    if isempty(tol) then
        tol=0;
    end
    
    //First remove trailing zeros of a else order of polynomial will be incorrect
    if ~isempty(a) then
        a_temp=a(1:length(a)-find(a($:-1:1)~=0,1)+1);
    else
        a_temp=a;
    end
    
    flag=1;
    
    //Find roots of polynomial a_temp
    z=roots(a_temp);
    if ~isempty(z) & (max(abs(z))>(1+tol)) then
        flag=0;
    end
endfunction

function flag=isminphase(b,tol)
    //isminphase To  return a logical value 'flag' which tells whether all roots of polynomial inside unit circle or not. If all roots inside unit circle then flag is 1, if not then flag is 0. 'tol' specifies the tolerance to determine when two numbers are close enough to be considered equal. If not specified then default value of eps^(2/3) is assumed for 'tol'. 
    
    if argn(2)<2 then
        tol=[];
    end
    
    if isempty(tol) then
        tol=%eps^(2/3);
    end
    
    flag=0;
    
    //Check for minimum phase i.e. all roots strictly inside unit circle.If not strictly minimum phase then tolerance 'tol' is also specified to check whether all roots inside unit circle within specified tolerance
    stableflag=isStable(b,tol);
    if stableflag then
        flag=1;
        return
    end
    
endfunction

function flag=checkmaxphase(b,a,tol)
    //checkmaxphase Does basic checks to establish whether the filter specified by numerator polynomial 'b' and denominator polynomial 'a' is max phase or not i.e. Checks whether all roots of 'b' strictly outside unit circle('flag'=T) or not ('flag'=F). 'tol' specifies the tolerance to determine when two numbers are close enough to be considered equal. If not specified then default value of eps^(2/3) is assumed for 'tol'.
    
    if argn(2)<3 then
        tol=[];
    end
    if isempty(tol) then
        tol=%eps^(2/3);
    end
    
    flag=%T;
    
    //Remove trailing zeros(else order of input polynomial will be incorrect) and find roots of b
    if ~isempty(b) then
        //remove trailing zeros
        b_temp=b(1:length(b)-find(b($:-1:1)~=0,1)+1);
    else
        b_temp=b;
    end
    
    //Checks for maximum phase: If there is a root at origin or filter is minimum phase then it won't qualify for maximum phase. Also additional checks done like stability and causality.
    if or(roots(b_temp)==0) | length(a)>length(b) | ~isminphase(conj(b($:-1:1)),tol) | ~isStable(a)
        flag=%F;
    end
endfunction
