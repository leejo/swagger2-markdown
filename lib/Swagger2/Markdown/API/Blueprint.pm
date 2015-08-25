package Swagger2::Markdown::API::Blueprint;

sub template {
    my ( $args ) = @_;

    my $template = _blueprint();
    return \$template;
}

1;

# vim: ft=tt2;ts=4:sw=4:et

sub _blueprint {

    return << 'EndOfBlueprint';
[%- BLOCK resource_section -%]
    [%- SWITCH f.resource_section -%]
        [%- CASE 'uri' -%]
# [% path _ "\n" -%]
        [%- CASE 'name_uri' -%]
# [% summary %] [[% path -%]][% "\n" -%]
        [%- CASE 'method_uri' -%]
# [% method | upper %] [% path -%][% "\n" -%]
        [%- CASE 'name_method_uri' -%]
# [% summary %] [[% method | upper %] [% path -%]][% "\n" -%]
        [%- CASE -%]
[% IF method.defined %]# [% method | upper %] [% path %][% END -%]
    [%- END -%]
[%- END -%]

[%- BLOCK action_section -%]
    [%- SWITCH f.action_section -%]
        [%- CASE 'method' -%]
## [% method | upper; "\n" -%]
        [%- CASE 'name_method' -%]
## [% summary %] [[% method | upper -%]][% "\n" -%]
        [%- CASE 'name_method_uri' -%]
## [% summary %] [[% method | upper %] [% path %]][% "\n" -%]
        [%- CASE -%]
[% IF method.defined %]# [% method | upper %] [% path %][% END -%]
    [%- END -%]
[%- END -%]
FORMAT: 1A

# [% s.info.title %]
[% s.info.description -%]

[% FOREACH path IN s.paths.keys -%]
    [%- description_key = 'x-api-blueprint' -%]
    [%- IF s.paths.$path.$description_key.defined -%]
        [%- summary = s.paths.$path.$description_key.summary -%]
    [%- END -%]
[% PROCESS resource_section %]
    [%- IF s.paths.$path.$description_key.defined -%]
[% s.paths.$path.$description_key.description _ "\n" -%]
    [%- END -%]
    [%- FOREACH method IN s.paths.$path.keys.sort -%]
        [%- IF method == description_key; NEXT; END -%]
        [%- summary = s.paths.$path.$method.summary -%]
[% PROCESS action_section %]
        [%- IF s.paths.$path.$method.description.defined -%]
[% s.paths.$path.$method.description %]
        [%- END -%]
        [%- IF s.paths.$path.$method.parameters.defined -%]

+ Request [% -%]
            [%- IF s.paths.$path.$method.consumes -%]
                [%- %]([% s.paths.$path.$method.consumes.0 %])
            [%- END %]
            [%- FOREACH parameter IN s.paths.$path.$method.parameters %]
            [%- END %]

        [% s.paths.$path.$method.parameters.0.schema.example %]

        [%- END -%]
        [%- FOREACH response IN s.paths.$path.$method.responses.keys %]
+ Response [% response -%]
            [%- IF s.paths.$path.$method.produces -%]
                [%- %] ([% s.paths.$path.$method.produces.0 %])
            [%- END %]
        [%- IF s.paths.$path.$method.responses.$response.schema %]

        [% s.paths.$path.$method.responses.$response.schema.example %]


        [%- END -%]
        [%- END -%]
    [%- END -%]
[%- END -%]
[%# USE Dumper; Dumper.dump( s.paths ) %]
EndOfBlueprint

}
