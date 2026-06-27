unit module DSL::Invoice::Actions;

use Actionable; use Form;

class Item does Actionable {
    has ($.description, $.hours, $.rate);
    method subtotal { $.hours * $.rate }
}

class Invoice does Actionable {
    has ($.id, $.date, $.client, $.tax-rate = 0);
    has Item @.items;

    method subtotal { @.items.map(*.subtotal).sum }
    method tax      { $.subtotal * $.tax-rate / 100 }
    method total    { $.subtotal + $.tax }
    method label    { "Tax ($!tax-rate%)" }

    method raku     {
        form( :interleave, q:to/INVOICE/,
            Invoice: {<<<<<}
            Date:    {<<<<<<<<}
            Client:  {<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<}

            Description                      Hours     Rate   Subtotal
            ----------------------------------------------------------
            {[[[[[[[[[[[[[[[[[[[[[[[[[[[[}  {]]].}  {]]].[}   {]]]].[}
            ----------------------------------------------------------
                                                  {]]]]]]]}   {]]]].[}
            INVOICE

            $.id, $.date, $.client,
            |[@.items.map(*."$_"()) for <description hours rate subtotal>],
            ["Subtotal", $.label, "Total"],
            [$.subtotal, $.tax,  $.total ],
              );
    }
}

class Actions {
    method TOP($/) {
        my $inv = Invoice.action($<head-line>);
        { $inv.action($_) } for $<info-line>;
        { $inv.items.push(Item.action($_)) } for $<item-line>;
        make $inv;
    }
}
