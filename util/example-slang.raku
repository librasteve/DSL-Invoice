use DSL::Invoice::Slang;

say invoice INV-002
    date 2026-06-27
    client "Globex Corp"

    item "Strategy consulting"  hours 8   rate 200
    item "Report writing"       hours 4   rate 150
    item "Presentation prep"    hours 3   rate 150

    tax 20%