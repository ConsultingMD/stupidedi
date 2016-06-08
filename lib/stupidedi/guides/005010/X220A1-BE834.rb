# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Guides
    module FiftyTen
      module X220A1

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FiftyTen::SegmentDefs
        t = Versions::FunctionalGroups::FiftyTen::TransactionSetDefs

        BE834 = b.build(t::BE834,
                        d::TableDef.header("Table 1 - Header",
                                           b::Segment(100, s::ST, "Transaction Set Header",
                                                      r::Required, d::RepeatCount.bounded(1),
                                                      b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("834")),
                                                      b::Element(e::Required,    "Transaction Set Control Number"),
                                                      b::Element(e::NotUsed,     "Implementation Guide Version Name")),
                                           b::Segment(200, s::BGN, "Beginning Segment",
                                                      r::Required, d::RepeatCount.bounded(1),
                                                      b::Element(e::Required,    "Original Transaction"),
                                                      b::Element(e::Required,    "Transaction ID"),
                                                      b::Element(e::Required,    "Date"),
                                                      b::Element(e::Required,    "Time"),
                                                      b::Element(e::Required,    "Central Time"),
                                                      b::Element(e::Required,    "Blank"),
                                                      b::Element(e::Required,    "Blank"),
                                                      b::Element(e::Required,    "Verify Action Code")),
                                           b::Segment(300, s::REF, "Reference Information",
                                                      r::Required, d::RepeatCount.bounded(1),
                                                      b::Element(e::Required,     "Master Policy Number"),
                                                      b::Element(e::Required,     "Reference Identification"),
                                                      b::Element(e::NotUsed,     ""),
                                                      b::Element(e::NotUsed,     "")),
                                           b::Segment(400, s::QTY, "Employee Quantity",
                                                      r::Required, d::RepeatCount.bounded(3),
                                                      b::Element(e::Required,     "Quantity Code"),
                                                      b::Element(e::Required,     "Quantity"),
                                                      b::Element(e::NotUsed,     ""),
                                                      b::Element(e::NotUsed,     "")),
                                           b::Segment(510, s::N1, "Foo",
                                                      r::Required, d::RepeatCount.bounded(2),
                                                      b::Element(e::Required,    ""),
                                                      b::Element(e::Required,    ""),
                                                      b::Element(e::NotUsed,     ""),
                                                      b::Element(e::NotUsed,     ""),
                                                      b::Element(e::NotUsed,     ""),
                                                      b::Element(e::NotUsed,     ""))),
                        d::TableDef.header("Table 2 - Covereds",
                                           d::LoopDef.build("1100", d::RepeatCount.unbounded,
                                                            s::INS.use(1200, r::Situational,  d::RepeatCount.unbounded),
                                                            s::REF.use(1300, r::Situational,  d::RepeatCount.unbounded),
                                                            s::DTP.use(1350, r::Situational, d::RepeatCount.unbounded),
                                                            s::REF.use(1300, r::Situational,  d::RepeatCount.unbounded))))

      end
    end
  end
end
