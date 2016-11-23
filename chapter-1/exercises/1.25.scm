; No, it wouldn't serve as well for our fast-prime tester because by returning the
; remainder from every call of expmod we keep the numbers we have to square 
; and divide at each recursive call relatively small (< the number to test) 
