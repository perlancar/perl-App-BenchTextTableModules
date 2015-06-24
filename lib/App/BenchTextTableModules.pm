package App::BenchTextTableModules;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %contestants = (
    'Text::ANSITable' => sub {
        my ($table) = @_;
        my $t = Text::ANSITable->new(
            use_utf8 => 0,
            use_box_chars => 0,
            use_color => 0,
            columns => $table->[0],
            border_style => 'Default::single_ascii',
        );
        $t->add_row($table->[$_]) for 1..@$table-1;
        $t->draw;
    },
    'Text::ASCIITable' => sub {
        my ($table) = @_;
        my $t = Text::ASCIITable->new();
        $t->setCols(@{ $table->[0] });
        $t->addRow(@{ $table->[$_] }) for 1..@$table-1;
        "$t";
    },
    'Text::FormatTable' => sub {
        my ($table) = @_;
        my $t = Text::FormatTable->new(join('|', ('l') x @{ $table->[0] }));
        $t->head(@{ $table->[0] });
        $t->row(@{ $table->[$_] }) for 1..@$table-1;
        $t->render;
    },
    'Text::MarkdownTable' => sub {
        my ($table) = @_;
        my $out = "";
        my $t = Text::MarkdownTable->new(file => \$out);
        my $fields = $table->[0];
        foreach (1..@$table-1) {
            my $row = $table->[$_];
            $t->add( {
                map { $fields->[$_] => $row->[$_] } 0..@$fields-1
            });
        }
        $t->done;
        $out;
    },
    'Text::Table' => sub {
        my ($table) = @_;
        my $t = Text::Table->new(@{ $table->[0] });
        $t->load(@{ $table }[1..@$table-1]);
        $t;
    },
    'Text::Table::Tiny' => sub {
        my ($table) = @_;
        Text::Table::Tiny::table(rows=>$table, header_row=>1);
    },
    'Text::TabularDisplay' => sub {
        my ($table) = @_;
        my $t = Text::TabularDisplay->new(@{ $table->[0] });
        $t->add(@{ $table->[$_] }) for 1..@$table-1;
        $t->render; # doesn't add newline
    },
);

1;
# ABSTRACT: Benchmark Perl text table modules

=head1 SYNOPSIS

See the included scripts:

#INSERT_EXECS_LIST
