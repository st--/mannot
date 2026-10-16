#import "/src/mark.typ": mark, markhl

#let approx(a, b) = calc.abs(a - b) < 1e-6 * 1pt

// Offset of the marker `inner` (placed inside an attachment) from the marker
// `start` (placed just before the term).
#let offset(start, inner) = {
  let a = query(start).first().location().position()
  let b = query(inner).first().location().position()
  (x: b.x - a.x, y: b.y - a.y)
}
#let same-offset(a, b) = approx(a.x, b.x) and approx(a.y, b.y)


= Attachments are placed as without the mark
$
  #[#metadata(none)<f-plain>] f_(#[#metadata(none)<f-plain-b>] i)
  quad
  #[#metadata(none)<f-mark>] mark(f_(#[#metadata(none)<f-mark-b>] i), tag: #<f>, base-only: #true)
  quad
  #[#metadata(none)<f-hl>] markhl(f_(#[#metadata(none)<f-hl-b>] i), base-only: #true)
  quad
  #[#metadata(none)<f-color>] mark(f_(#[#metadata(none)<f-color-b>] i), #red, base-only: #true)
$
$
  #[#metadata(none)<p-plain>] P_(#[#metadata(none)<p-plain-b>] i)^(#[#metadata(none)<p-plain-t>] 2)
  quad
  #[#metadata(none)<p-mark>] mark(P_(#[#metadata(none)<p-mark-b>] i)^(#[#metadata(none)<p-mark-t>] 2), tag: #<p>, base-only: #true)
$
#context {
  let plain = offset(<f-plain>, <f-plain-b>)
  assert(same-offset(plain, offset(<f-mark>, <f-mark-b>)))
  assert(same-offset(plain, offset(<f-hl>, <f-hl-b>)))
  assert(same-offset(plain, offset(<f-color>, <f-color-b>)))
  assert(same-offset(offset(<p-plain>, <p-plain-b>), offset(<p-mark>, <p-mark-b>)))
  assert(same-offset(offset(<p-plain>, <p-plain-t>), offset(<p-mark>, <p-mark-t>)))
}


= The mark ends at the right edge of the base
Display: $ mark(f_i, tag: #<display>, base-only: #true) $
Inline: $mark(f_i, tag: #<inline>, base-only: #true)$,
script: $x_(mark(f_i, tag: #<script>, base-only: #true))$,
fraction: $1 / mark(P_i^2, tag: #<frac>, base-only: #true)$
$
  mark(sum_(i=1)^n, tag: #<sum>, base-only: #true) x_i
  + markhl(f_i, tag: #<hl>, base-only: #true) + markhl(f_i)
$
#context {
  let width(tag) = query(tag).first().value.mark-bounds.width
  let base(style, body) = measure(math.equation(style(body), block: false)).width
  assert(approx(width(<display>), base(math.display, $f$.body)))
  assert(approx(width(<inline>), base(math.inline, $f$.body)))
  assert(approx(width(<script>), base(math.script, $f$.body)))
  // (an inline fraction sets its denominator at script size)
  assert(approx(width(<frac>), base(math.script, $P$.body)))
  assert(approx(width(<sum>), base(math.display, $sum$.body)))
  assert(approx(width(<hl>), base(math.display, $f$.body)))
}


= Without attachments, `base-only` has no effect
$
  mark(x + y, tag: #<no-attach>, base-only: #true)
  quad
  mark(x + y, tag: #<no-attach-ref>)
$
#context {
  let data = query(<no-attach>).first().value
  let ref = query(<no-attach-ref>).first().value
  assert(approx(data.mark-bounds.width, ref.mark-bounds.width))
  assert(approx(data.mark-bounds.height, ref.mark-bounds.height))
}
