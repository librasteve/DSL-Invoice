unit module DSL::Invoice;

use DSL::Invoice::Grammar;
use DSL::Invoice::Actions;

sub parse(Str $text) is export {
    DSL::Invoice::Grammar.parse($text, :actions(DSL::Invoice::Actions::Actions.new)).made;
}
