using SpecialFunctions
export adiff, mod2piF, fresnelS, fresnelC

if !isdefined(:sincos)    # sincos will exist in Julia 0.7
    @inline sincos(x) = sin(x), cos(x)
end
@inline mod2piF(x::T) where {T<:AbstractFloat} = mod(x, 2*T(pi))
@inline function adiff(x::T, y::T) where {T<:AbstractFloat}
    d = mod2piF(x - y)
    d <= π ? d : d - 2*T(π)
end
function fresnelS0(x::T) where {T<:AbstractFloat}
    x2 = x*x
    x4 = x2*x2
    n = @evalpoly(x4, T(3.18016297876567817986E11),
                      -T(4.42979518059697779103E10),
                      T(2.54890880573376359104E9),
                      -T(6.29741486205862506537E7),
                      T(7.08840045257738576863E5),
                      -T(2.99181919401019853726E3))
    d = @evalpoly(x4, T(6.07366389490084639049E11),
                      T(2.24411795645340920940E10),
                      T(4.19320245898111231129E8),
                      T(5.17343888770096400730E6),
                      T(4.55847810806532581675E4),
                      T(2.81376268889994315696E2),
                      T(1))
    x*x2*n/d
end
function fresnelC0(x::T) where {T<:AbstractFloat}
    x2 = x*x
    x4 = x2*x2
    n = @evalpoly(x4, T(9.99999999999999998822E-1),
                      -T(2.05525900955013891793E-1),
                      T(1.88843319396703850064E-2),
                      -T(6.45191435683965050962E-4),
                      T(9.50428062829859605134E-6),
                      -T(4.98843114573573548651E-8))
    d = @evalpoly(x4, T(1.00000000000000000118E0),
                      T(4.12142090722199792936E-2),
                      T(8.68029542941784300606E-4),
                      T(1.22262789024179030997E-5),
                      T(1.25001862479598821474E-7),
                      T(9.15439215774657478799E-10),
                      T(3.99982968972495980367E-12))
    x*n/d
end
fresnelS(x::T) where {T<:AbstractFloat} = x < T(1.6) ? fresnelS0(x) : imag((1+im)*erf(x*sqrt(T(pi))*(1 - im)/2)/2)
fresnelC(x::T) where {T<:AbstractFloat} = x < T(1.6) ? fresnelC0(x) : real((1+im)*erf(x*sqrt(T(pi))*(1 - im)/2)/2)