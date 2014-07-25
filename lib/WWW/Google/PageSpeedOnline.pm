package WWW::Google::PageSpeedOnline;

$WWW::Google::PageSpeedOnline::VERSION = '0.09';

use 5.006;

use Moo;
use namespace::clean;

=head1 NAME

WWW::Google::PageSpeedOnline - Interface to Google Page Speed Online API.

=head1 VERSION

Version 0.09

=cut

=head1 DESCRIPTION

Google Page  Speed  is  a tool that helps developers optimize their web pages  by
analyzing the pages and generating tailored suggestions to make the pages faster.
You  can  use  the  Page Speed Online API to programmatically generate Page Speed
scores and suggestions.  Currently it  supports version v1. Courtesy limit is 250
queries per day.

IMPORTANT: The  version v1 of the Google Page Speed Online API is in Labs and its
features might change unexpectedly until it graduates.

=head1 STRATEGIES

    +-------------+
    | Strategy    |
    +-------------+
    | desktop     |
    | mobile      |
    +-------------+

=head1 RULES

    +---------------------------------------+
    | Rule                                  |
    +---------------------------------------+
    | AvoidCssImport                        |
    | InlineSmallJavaScript                 |
    | SpecifyCharsetEarly                   |
    | SpecifyACacheValidator                |
    | SpecifyImageDimensions                |
    | MakeLandingPageRedirectsCacheable     |
    | MinimizeRequestSize                   |
    | PreferAsyncResources                  |
    | MinifyCss                             |
    | ServeResourcesFromAConsistentUrl      |
    | MinifyHTML                            |
    | OptimizeTheOrderOfStylesAndScripts    |
    | PutCssInTheDocumentHead               |
    | MinimizeRedirects                     |
    | InlineSmallCss                        |
    | MinifyJavaScript                      |
    | DeferParsingJavaScript                |
    | SpecifyAVaryAcceptEncodingHeader      |
    | LeverageBrowserCaching                |
    | OptimizeImages                        |
    | SpriteImages                          |
    | RemoveQueryStringsFromStaticResources |
    | ServeScaledImages                     |
    | AvoidBadRequests                      |
    | UseAnApplicationCache                 |
    +---------------------------------------+

=head1 LOCALES

    +-------+------------------------------+
    | Code  | Description                  |
    +-------+------------------------------+
    | ar    | Arabic                       |
    | bg    | Bulgarian                    |
    | ca    | Catalan                      |
    | zh_TW | Traditional Chinese (Taiwan) |
    | zh_CN | Simplified Chinese           |
    | fr    | Croatian                     |
    | cs    | Czech                        |
    | da    | Danish                       |
    | nl    | Dutch                        |
    | en_US | English                      |
    | en_GB | English UK                   |
    | fil   | Filipino                     |
    | fi    | Finnish                      |
    | fr    | French                       |
    | de    | German                       |
    | el    | Greek                        |
    | lw    | Hebrew                       |
    | hi    | Hindi                        |
    | hu    | Hungarian                    |
    | id    | Indonesian                   |
    | it    | Italian                      |
    | ja    | Japanese                     |
    | ko    | Korean                       |
    | lv    | Latvian                      |
    | lt    | Lithuanian                   |
    | no    | Norwegian                    |
    | pl    | Polish                       |
    | pr_BR | Portuguese (Brazilian)       |
    | pt_PT | Portuguese (Portugal)        |
    | ro    | Romanian                     |
    | ru    | Russian                      |
    | sr    | Serbian                      |
    | sk    | Slovakian                    |
    | sl    | Slovenian                    |
    | es    | Spanish                      |
    | sv    | Swedish                      |
    | th    | Thai                         |
    | tr    | Turkish                      |
    | uk    | Ukrainian                    |
    | vi    | Vietnamese                   |
    +-------+------------------------------+

=head1 CONSTRUCTOR

The constructor expects at the least the API Key that you can get from Google for
FREE. You can also provide prettyprint switch as well, which can have either true
or false values.You can pass param as scalar the API key, if that is the only the
thing you would want to pass in.In case you would want to pass prettyprint switch
then you would have to pass as hashref like:

    +-------------+----------------------------------------------------------------------------------+
    | Parameter   | Meaning                                                                          |
    +-------------+----------+-----------------------------------------------------------------------+
    | api_key     | API Key (required)                                                               |
    | prettyprint | Returns the response in a human-readable format. Default value is true.          |
    +-------------+----------------------------------------------------------------------------------+

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    # or
    $page    = WWW::Google::PageSpeedOnline->new({api_key => $api_key});
    # or
    $page    = WWW::Google::PageSpeedOnline->new({api_key=>$api_key, prettyprint=>'true'});

=head1 METHODS

=head2 process()

    +-----------+----------+-----------------------------------------------------------------------------------+
    | Parameter | Default  | Meaning                                                                           |
    +-----------+----------+-----------------------------------------------------------------------------------+
    | url       | Required | The URL of the page for which the Page Speed Online API should generate results.  |
    | locale    | en-US    | The locale that results should be generated in.                                   |
    | strategy  | desktop  | The strategy to use when analyzing the page. Valid values are desktop and mobile. |
    | rule      | N/A      | The Page Speed rules to run. Can have multiple rules something like for example,  |
    |           |          | ['AvoidBadRequests', 'MinifyJavaScript'] to request multiple rules.               |
    +-----------+----------+-----------------------------------------------------------------------------------+

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});

=cut

=head2 get_stats()

Returns the page stats in XML format, something like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageStats>
        <Hosts unit="number">7</Hosts>
        <Request unit="bytes">2711</Request>
        <Response unit="bytes">
                <HTML>92198</HTML>
                <CSS>37683</CSS>
                <Image>13906</Image>
                <Javascript>247174</Javascript>
                <Other>8802</Other>
        </Response>
        <Resources unit="number">
                <Static>16</Static>
                <CSS>2</CSS>
                <Javascript>6</Javascript>
                <Resource>22</Resource>
        </Resources>
    </PageStats>

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $stats);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $stats   = $page->get_stats();

=cut

=head2 get_result()

Returns the page result in XML format, like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageResults>
        <Rule name="Avoid CSS @import" impact="0" score="100"/>
        <Rule name="Inline Small JavaScript" impact="0" score="100"/>
        <Rule name="Specify a character set" impact="0" score="100"/>
        <Rule name="Specify a cache validator" impact="1" score="75"/>
        <Rule name="Specify image dimensions" impact="0" score="100"/>
        <Rule name="Make landing page redirects cacheable" impact="0" score="100"/>
        ....
        ....
        ....
    </PageResults>

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $result);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $result  = $page->get_result();

=cut

=head2 get_advise()

Returns the page advise in XML format, like below:

    <?xml version="1.0" encoding="UTF-8"?>
    <PageAdvise>
        <Rule id="DeferParsingJavaScript">
                <Header>232.9KiB of JavaScript is parsed during initial page load. Defer parsing JavaScript to reduce blocking of page rendering.</Header>
                <Items>
                        <Item>http://code.google.com/js/codesite_head.pack.04102009.js (65.4KiB)</Item>
                        ....
                        ....
                        ....
                </Items>
        </Rule>
        <Rule id="LeverageBrowserCaching">
                <Header>The following cacheable resources have a short freshness lifetime. Specify an expiration at least one week in the future for the following resources:</Header>
                <Items>
                        <Item>http://google-code-feed-gadget.googlecode.com/svn/trunk/images/cleardot.gif (3 minutes)</Item>
                        <Item>http://code.google.com/css/codesite.pack.04102009.css (60 minutes)</Item>
                        ....
                        ....
                        ....
        </Rule>
        ....
        ....
        ....
    </PageAdvise>

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $advise);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $advise  = $page->get_advise();

=cut

=head2 get_score()

Returns the page score.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $score);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $score   = $page->get_score();

=cut

=head2 get_title()

Returns the page title.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $title);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $title   = $page->get_title();

=cut

=head2 get_id()

Returns the page id.

    use strict; use warnings;
    use WWW::Google::PageSpeedOnline;

    my ($api_key, $page, $id);
    $api_key = 'Your_API_Key';
    $page    = WWW::Google::PageSpeedOnline->new($api_key);
    $page->process({url => 'http://code.google.com/speed/page-speed/'});
    $id      = $page->get_id();

=cut

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-pagespeedonline at
rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-PageSpeedOnline>.
I will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::PageSpeedOnline

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-PageSpeedOnline>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-PageSpeedOnline>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-PageSpeedOnline>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-PageSpeedOnline/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Mohammad S Anwar.

This  program  is  free software; you can redistribute it and/or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of WWW::Google::PageSpeedOnline
