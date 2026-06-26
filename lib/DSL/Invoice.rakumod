unit module DSL::Invoice;

grammar Grammar {
    token ws  { \h* }
    token TOP {
        <head-line>
        [ \n+ <.ws> [ <info-line> | <item-line> ] ]*
        \n*
    }
    rule  head-line { invoice  <id>                  }
    rule  info-line { | date   <date>
                      | client <client=quoted>
                      | tax    <tax-rate=number> '%' }
    rule  item-line { item     <description=quoted>
                      hours    <hours=number>
                      rate     <rate=number>         }
    token id        { <[A..Za..z0..9_\-]>+       }
    token date      { \d**4 '-' \d**2 '-' \d**2 }
    token number    { \d+ [ '.' \d+ ]?          }
    token quoted    { '"' <( <-["]>+ )> '"'     }
}

class Item {
    has $.description; has $.hours; has $.rate;
    method subtotal { $!hours * $!rate }
}

class Invoice {
    has $.id; has $.date; has $.client; has $.tax-rate = 0;
    has Item @.items;
    method subtotal { @!items.map(*.subtotal).sum }
    method tax      { $.subtotal * $!tax-rate }
    method total    { $.subtotal + $.tax }
    method label    { "Tax ({($!tax-rate * 100).Int}%)" }
    method raku     { self.Str }
    method Str {
        qq:to/RENDER/.chomp
        Invoice: $!id
        Date:    $!date
        Client:  $!client

        { sprintf("%-30s %6s %8s %10s", "Description", "Hours", "Rate", "Subtotal") }
        { "-" x 58 }
        { @!items.map({ sprintf("%-30s %6.1f %8.2f %10.2f", .description, .hours, .rate, .subtotal) }).join("\n") }
        { "-" x 58 }
        { sprintf("%46s %10.2f", "Subtotal", $.subtotal) }
        { sprintf("%46s %10.2f", $.label,    $.tax) }
        { sprintf("%46s %10.2f", "Total",    $.total) }
        RENDER
    }
}

class Actions {
    method info-line($/) {
        make $<date>   ?? { date     => ~$<date> }
          !! $<client> ?? { client   => ~$<client> }
          !!              { tax-rate => (+$<tax-rate>) / 100 }
    }
    method item-line($/) {
        make Item.new(description => ~$<description>,
                      hours       => +$<hours>,
                      rate        => +$<rate>)
    }
    method TOP($/) {
        my %info = $<info-line>.map(*.made.pairs).flat;
        make Invoice.new(id    => ~$<head-line><id>,
                         |%info,
                         items => $<item-line>.map(*.made).Array);
    }
}

sub parse(Str $text) is export {
    Grammar.parse($text, :actions(Actions.new)).made;
}
