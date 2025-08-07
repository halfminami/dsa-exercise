# reading:
# Algorithms by S. Dasgupta, C.H. Papadimitriou, and U.V. Vazirani
# Figure 2.9

# for human
ComplexToRad ← ∠°ℂ
RadToDeg     ← ×360÷τ

NthRootOfUnity ← ℂ°∠ ¯÷:τ

# The length of `Coefficients` is power of 2.
# Vector ? Coefficients NthRootOfUnity
FftRec ← |2 (
  >1⊸⧻
  ⨬(⊙◌
  | ∩▽⊃(⊙⋅∘|⋅⊙∘)⊸¬◿2°⊏ # coefficients at even and odd
    ⊙(⊃(⋅∘|⊙⊙∘)⊙⊸°√)
    ∩FftRec
    :⊙×⊙⊙(ⁿ⇡)⊙⟜⧻
    ⊂⊃(+|-)
  )
)

NextPowerOfTwo ← ⁿ:2⌈⌝˜ⁿ2

# Zero-pads if the length of `Coefficients` is not power of 2.
# Vector ? Coefficients
Fft ← FftRec :⊙⬚0↙⊸NthRootOfUnity NextPowerOfTwo⊸⧻

┌─╴test
  # I still don't quite understand the algorithm
  # but I found out that the output is some multiple of that of fft if the
  # length of the input is power of two

  Run ← (
    ×÷⊙:∩⊸⊢⊃fft Fft
    ∩≡(⊂:°⊂⁅₈[°ℂ])
  )

  ⍤⤙≍ [] Fft []
  ⍤⤙≍ Run [1]
  ⍤⤙≍ Run [1 4]
  ⍤⤙≍ Run [1 4 0 2]
  ⍤⤙≍ Run [1 1 1 1 0 0 0 0]
  ⍤⤙≍ Run [0 0 0 0 1 1 1 1]
  ⍤⤙≍ Run [1 1 1 1 1 1 1 1]
  ⍤⤙≍ Run [3 13 1.1 8 ¯2 42 ¯1 ¯1.1]
  ⍤⤙≍ Run÷⟜⇡256
  ⍤⤙≍ Run÷⟜⇡512
  ⍤⤙≍ Run÷⟜⇡1024
└─╴
