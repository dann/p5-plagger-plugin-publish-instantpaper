use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plagger::Plugin::Publish::Instantpaper/],
    style   => 'light';
ok_dependencies();
