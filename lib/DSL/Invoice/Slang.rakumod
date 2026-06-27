use DSL::Invoice;

my role Grammar {
    token term:sym<invoice> {
        'invoice'
        $<dsl> = [ <-[;]>* ]
    }
}

my role Actions {
    method term:sym<invoice>(Mu $/) {
        my $text := 'invoice' ~ ~$<dsl>;
        if self.^name.starts-with('Raku::') {
            use experimental :rakuast;
            make RakuAST::Call::Name.new(
                name => RakuAST::Name.from-identifier-parts('DSL', 'Invoice', 'parse'),
                args => RakuAST::ArgList.new(
                    RakuAST::StrLiteral.new($text)
                )
            );
        }
        else {
            use QAST:from<NQP>;
            make QAST::Op.new(
                :op('call'),
                QAST::WVal.new(:value(&parse)),
                QAST::SVal.new(:value($text))
            );
        }
    }
}

use Slangify Grammar, Actions;
