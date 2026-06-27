unit grammar DSL::Invoice::Grammar;

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
