use lib '../lib';
use DSL::Invoice;

my $EXAMPLE = q:to/END/;
invoice INV-001
  date 2026-04-29
  client "Acme Corp"

  item "Website redesign"  hours 10  rate 150
  item "Hosting setup"     hours 2   rate 100

  tax 8%
END

say parse($EXAMPLE);
