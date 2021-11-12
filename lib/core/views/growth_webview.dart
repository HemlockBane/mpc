import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GrowthWebView extends StatefulWidget {

  GrowthWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<StatefulWidget> createState() => GrowthWebViewState();

}

class GrowthWebViewState extends State<GrowthWebView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    // convertedPage = "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kNavigationExamplePage))}";
    print("Calling WebView Set State");
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  String convertedPage = "";
  static String kNavigationExamplePage = '''
<!DOCTYPE html>

<html>

<body style="font-family: Roboto Mono Light !important; background-color: #F2F7FE;">

<!-- RECEIPT CONTAINER  -->
<div style="margin: 25px auto 0 auto; width: 400px; height: auto; background-color: #fff;
    box-shadow: 0px 20px 20px rgba(14, 79, 177, 0.12); border-radius: 15px 15px 0 0">

    <!-- OPTIONAL CATEGORY HEADER -->
    <div style="padding: 10px 20px 0; height: 65px; background-color: #ECDFF9; border-radius: 15px 15px 0 0">
        <!-- TRANSFER: #CFE2FD, AIRTIME: #FDEAD5, BILL PAYMENT: #ECDFF9, CARD: #CFF2F7 -->
        <table width="100%">
            <tr>
                <td style="padding: 0; margin: 0;" width="10%">
                    <svg xmlns="http://www.w3.org/2000/svg" width="17" height="19" viewBox="0 0 17 19" fill="none">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M2.64266 0.128906C1.34874 0.128906 0.299805 1.17784 0.299805 2.47176V18.8718L4.3998 16.5289L8.4998 18.8718L12.5998 16.5289L16.6998 18.8718V2.47176C16.6998 1.17784 15.6509 0.128906 14.3569 0.128906H2.64266ZM5.57123 3.64319C4.60079 3.64319 3.81409 4.42989 3.81409 5.40033C3.81409 6.37078 4.60079 7.15748 5.57123 7.15748C6.54168 7.15748 7.32838 6.37078 7.32838 5.40033C7.32838 4.42989 6.54168 3.64319 5.57123 3.64319ZM12.8424 3.98629C12.3849 3.52882 11.6432 3.52882 11.1858 3.98629L4.15719 11.0149C3.69972 11.4723 3.69972 12.214 4.15719 12.6715C4.61466 13.129 5.35637 13.129 5.81384 12.6715L12.8424 5.64294C13.2999 5.18547 13.2999 4.44377 12.8424 3.98629ZM11.4284 9.50033C10.4579 9.50033 9.67123 10.287 9.67123 11.2575C9.67123 12.2279 10.4579 13.0146 11.4284 13.0146C12.3988 13.0146 13.1855 12.2279 13.1855 11.2575C13.1855 10.287 12.3988 9.50033 11.4284 9.50033Z" fill="#9B51E0"/>
                    </svg>
                </td>
                <td style="padding: 0; margin: 0;" width="90%">
                    <p style="font-weight: 600; font-size: 12px;letter-spacing: 0.035em;
                        color: #9B51E0;">
                        <!-- TRANSFER: #0361F0, AIRTIME: #F08922, BILL PAYMENT: #9B51E0, CARD: #CFF2F7 -->
                        BILL PAYMENT
                    </p>
                </td>
            </tr>
        </table>
    </div>


    <!-- OTHER CONTENTS -->
    <div style="margin-top: -15px; width: 100%; background-color: #fff; border-radius: 15px 15px 0 0">

        <!-- AMOUNT HEADER -->
        <table width="100%" style="margin-bottom: 10px;">
            <tr>
                <td style="padding: 20px 20px 0; margin: 0;">
                    <p style="margin: 0 0 5px;">Amount</p>
                    <p style="margin: 0 0 5px; font-weight: 700; font-size: 34px;">
                        <span>N</span>10,000.00
                    </p>
                </td>
                <td style="padding: 0 20px 0 0; margin: 0;">
                    <#if transactionType == "CREDIT">
                        <div style="background: #D9F2DB; display:inline-block; padding: 4px 7px; border-radius: 5px; float: right; margin-top: 40px;">
                            <p style="font-size: 12px; font-weight: 700; color: #1EB12D; margin: 0;">CREDIT</p>
                        </div>
                    </#if>
                    <#if transactionType == "DEBIT">
                        <div style="background: #FBDFDF; display:inline-block; padding: 4px 7px; border-radius: 5px; float: right; margin-top: 40px;">
                            <p style="font-size: 12px; font-weight: 700; color: #E94444; margin: 0;">DEBIT</p>
                        </div>
                    </#if>
                </td>
            </tr>
        </table>

        <!-- DIVIDER  -->
        <hr style="margin: 0; height: 1px; background-color: #CDDFFC; border: none;"/>

        <!-- ACCOUNT NUMBER -->
        <p style="margin: 20px 20px 0;">
            Account Number: <span style="font-weight: 500;">0118403732</span>
        </p>

        <!-- OTHER DETAIL CONTAINER -->
        <div
                style="margin: 25px auto 0 auto; padding: 0 0 20px 0; width: 360px; background-color: #F2F7FE; border-radius: 10px;">
            <table width="100%">

                <!-- AIRTIME/BILL PAYMENT BENEFICIARY (OPTIONAL) -->
                <#if beneficiary??>
                    <tr>
                        <td style="padding: 20px 15px 0; margin: 0;">
                            <p style="margin: 0 0 5px 0; font-size: 0.9em; font-weight: 300;">Beneficiary</p>
                            <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">Paul Okeke</p>

                            <p style="margin: 15px 0 5px; font-size: 0.9em; font-weight: 300;">Smartcard Number</p>
                            <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">0118493732</p>
                        </td>
                    </tr>
                </#if>
                <tr>
                    <td style="padding: 0 15px; margin: 0;">
                        <img style="margin: 10px 0 15px; height: 45px; float: left;" src=""/>
                        <p style="margin: 25px 0 0 5px; font-size: 0.9em; font-weight: 500; float: left;">
                            GTB</p>

                        <!-- DIVIDER  -->
                        <hr
                                style="margin: 20px 0 0; height: 1px; background-color: #CDDFFC; border: none; clear: both;"/>
                    </td>
                </tr>

                <!-- NARRATION (IF NOT NULL/EMPTY) -->
                <tr>
                    <td style="padding: 20px 15px 0; margin: 0;">
                        <p style="margin: 0 0 5px 0; font-size: 0.9em; font-weight: 300;">Narration</p>
                        <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">weewewew</p>
                        <!-- DIVIDER  -->
                        <hr style="margin: 20px 0 0; height: 1px; background-color: #CDDFFC; border: none;"/>
                    </td>
                </tr>

                <!-- TRANSACTION DATE -->
                <tr>
                    <td style="padding: 20px 15px 0; margin: 0;">
                        <p style="margin: 0 0 5px 0; font-size: 0.9em; font-weight: 300;">Transaction Date</p>
                        <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">wewewe</p>
                        <!-- DIVIDER  -->
                        <hr style="margin: 20px 0 0; height: 1px; background-color: #CDDFFC; border: none;"/>
                    </td>
                </tr>

                <!-- CHANNEL (IF NOT NULL/EMPTY) -->
                <tr>
                    <td style="padding: 20px 15px 0; margin: 0;">
                        <p style="margin: 0 0 7px 0; font-size: 0.9em; font-weight: 300;">Channel</p>
                        <div
                                style="background: #CFE2FD; display:inline-block; padding: 4px 7px; border-radius: 5px;">
                            <p style="font-size: 12px; font-weight: 700; color: #0361F0; margin: 0;">wwww</p>
                        </div>
                        <!-- DIVIDER  -->
                        <hr style="margin: 20px 0 0; height: 1px; background-color: #CDDFFC; border: none;"/>
                    </td>
                </tr>

                <!-- REFERNCE (IF NOT NULL/EMPTY) -->
                <tr>
                    <td style="padding: 20px 15px 0; margin: 0;">
                        <p style="margin: 0 0 5px 0; font-size: 0.9em; font-weight: 300;">Reference</p>
                        <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">wewew</p>
                    </td>
                </tr>

                <#if transactionCode??>
                    <!-- TRANSACTION CODE (IF NOT NULL/EMPTY) -->
                    <tr>
                        <td style="padding: 20px 15px 0; margin: 0;">
                            <!-- DIVIDER  -->
                            <hr style="margin: 20px 0 0; height: 1px; background-color: #CDDFFC; border: none;"/>

                            <p style="margin: 0 0 5px 0; font-size: 0.9em; font-weight: 300;">Transaction Code</p>
                            <p style="margin: 5px 0; font-size: 1em; font-weight: 500;">eewe</p>
                        </td>
                    </tr>
                </#if>
            </table>
        </div>

        <!-- LOGO -->
        <br/>
        <img style="width: 150px; margin: 30px 125px 20px;" src=""/>

    </div>

</div>

<!-- RECEIPT BOTTOM -->
<div style="margin: 0 auto; width: 400px;">
    <img style="width: 400px;" src=""/>
</div>

</body>

</html>
''';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 200,
      child: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) async {
          print(request.url);
          return NavigationDecision.prevent;
        },
        onProgress: (k) {

        },
        onWebViewCreated: (controller) async {
          print("WebView ====> Created!!! ${await controller.currentUrl()}");
        },
        onWebResourceError: (error) {
          print("WebView ====> Error!!! ${error.description}");
        },
      ),
    );
    // return Container(
    //   key: ValueKey("ContainerColumnParentContainer"),
    //   height: 200,
    //   clipBehavior: Clip.hardEdge,
    //   decoration: BoxDecoration(
    //       color: Colors.transparent,
    //       borderRadius: BorderRadius.circular(16),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withOpacity(0.2),
    //         offset: Offset(0, 2),
    //         blurRadius: 21
    //       )
    //     ]
    //   ),
    //   child: Column(
    //     key: ValueKey("ColumnParentContainer"),
    //     children: [
    //       Expanded(
    //           key: ValueKey("ExpandedParentContainer"),
    //           child: Container(
    //             key: ValueKey("ParentContainer"),
    //             clipBehavior: Clip.hardEdge,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(16),
    //             ),
    //             child: WebView(
    //               key: ValueKey(widget.url),
    //               initialUrl: convertedPage,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               navigationDelegate: (request) async {
    //                 print(request.url);
    //                 return NavigationDecision.prevent;
    //               },
    //               onWebViewCreated: (controller) async {
    //                 print("WebView ====> Created!!! ${await controller.currentUrl()}");
    //               },
    //               onWebResourceError: (error) {
    //                 print("WebView ====> Error!!! ${error.description}");
    //               },
    //             ),
    //           )
    //       )
    //     ],
    //   ),
    // );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

}