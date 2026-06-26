[![Actions Status](https://github.com/librasteve/DSL-Invoice/actions/workflows/test.yml/badge.svg)](https://github.com/librasteve/DSL-Invoice/actions)

# DSL::Invoice

## Synopsis

```raku
use DSL::Invoice;

my $text = q:to/END/;
invoice INV-001
  date 2026-04-29
  client "Acme Corp"

  item "Website redesign"  hours 10  rate 150
  item "Hosting setup"     hours 2   rate 100

  tax 8%
END

say parse($text);
```

## Description

DSL::Invoice is a plain-text invoice DSL for Raku. Write invoices in a simple, readable format and get back structured objects with subtotal, tax, and total calculations — plus a formatted text render.

## Installation

```
zef install DSL::Invoice
```

## Author

librasteve <librasteve@furnival.net>

## Copyright and License

Copyright 2026 Stephen Roe.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
