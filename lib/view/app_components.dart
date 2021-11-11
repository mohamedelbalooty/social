import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:toast/toast.dart';
import '../icon_broken.dart';

class BuildAuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Key key;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final Function validate;

  const BuildAuthTextFormField({
    @required this.key,
    @required this.controller,
    @required this.hint,
    @required this.icon,
    @required this.keyboardType,
    @required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        TextFormField(
          key: key,
          controller: controller,
          validator: validate,
          keyboardType: keyboardType,
          cursorColor: whiteColor,
          style: const TextStyle(
            fontSize: 16.0,
            color: whiteColor,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 11.5,
            ),
            filled: true,
            fillColor: Color(0xFFFF5558),
            hintText: hint,
            hintStyle: const TextStyle(
              color: whiteColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            errorStyle: const TextStyle(
              color: whiteColor,
              fontSize: 14.0,
              height: 1.2,
            ),
            enabledBorder: _buildTextFieldBorder(),
            errorBorder: _buildTextFieldBorder(),
            focusedBorder: _buildTextFieldBorder(),
            focusedErrorBorder: _buildTextFieldBorder(),
          ),
        ),
        Container(
          height: 45.0,
          width: 45.0,
          decoration: BoxDecoration(
            color: whiteColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: mainColor,
              size: 22.0,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildTextFieldBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
      borderSide: BorderSide(
        color: whiteColor,
        width: 1.0,
      ),
    );
  }
}

class BuildDefaultOutlineBorderTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Key key;
  final String label;
  final IconData prefixIcon;
  final Function validate;
  final double borderRadius;

  const BuildDefaultOutlineBorderTextFormField({
    @required this.key,
    @required this.controller,
    @required this.label,
    @required this.prefixIcon,
    this.validate,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      validator: validate,
      keyboardType: TextInputType.text,
      autocorrect: true,
      cursorColor: mainColor,
      style: const TextStyle(
        fontSize: 12.0,
        color: darkMainColor,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsetsDirectional.only(end: 10.0),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          height: 1.2,
        ),
        errorStyle: const TextStyle(
          color: mainColor,
          fontSize: 14.0,
          height: 1.2,
        ),
        prefixIcon: Icon(prefixIcon),
        enabledBorder: _buildEnabledTextFieldBorder(),
        errorBorder: _buildEnabledTextFieldBorder(),
        focusedBorder: _buildFocusedTextFieldBorder(),
        focusedErrorBorder: _buildEnabledTextFieldBorder(),
      ),
    );
  }

  OutlineInputBorder _buildEnabledTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide(color: greyColor, width: 1.5),
    );
  }

  OutlineInputBorder _buildFocusedTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide(color: mainColor, width: 1.5),
    );
  }
}

class BuildDefaultUnderlineBorderTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Key key;
  final String hint;

  const BuildDefaultUnderlineBorderTextFormField({
    @required this.key,
    @required this.controller,
    @required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: TextInputType.text,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      cursorColor: mainColor,
      style: const TextStyle(
        fontSize: 12.0,
        color: darkMainColor,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(
          color: greyColor,
          fontSize: 14.0,
          height: 1.2,
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

class BuildAppGradientBackground extends StatelessWidget {
  final Widget widgetBody;

  const BuildAppGradientBackground({@required this.widgetBody});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [firstGradientColor, mainColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        widgetBody,
      ],
    );
  }
}

class BuildAppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      width: 160.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            child: Container(
              height: 110.0,
              width: 110.0,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
            ),
            angle: pi / 4,
          ),
          Image.asset(
            'assets/icons/logo.png',
            height: 90.0,
            width: 90.0,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

class BuildAuthenticationViewTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Social',
          style: _titleStyle(),
        ),
        Text(
          'App',
          style: _titleStyle().copyWith(color: Colors.amber),
        ),
      ],
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      color: whiteColor,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      height: 1.3,
    );
  }
}

class BuildAuthenticationViewSupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Communicate with friends',
      style: TextStyle(
        letterSpacing: 1.0,
        color: Color(0xFFD9DCDF),
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }
}

SizedBox constDistance() {
  return const SizedBox(
    height: 20.0,
  );
}

class BuildAuthQuestion extends StatelessWidget {
  final Key key;
  final String questionTitle;
  final String authTitle;
  final Function onClick;

  const BuildAuthQuestion({
    @required this.key,
    @required this.questionTitle,
    @required this.authTitle,
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionTitle,
          style: _titleStyle(),
        ),
        const SizedBox(
          width: 5.0,
        ),
        TextButton(
          key: key,
          child: Text(
            authTitle,
            style: _titleStyle(),
          ),
          onPressed: onClick,
        ),
      ],
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      color: whiteColor,
      fontSize: 14.0,
      height: 1.1,
    );
  }
}

class BuildSubmitAuthButton extends StatelessWidget {
  final Function() onClick;
  final String buttonTitle;

  const BuildSubmitAuthButton(
      {@required this.onClick, @required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: mainColor.withOpacity(0.2),
      child: Container(
        height: 45.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
          border: Border.all(
            color: mainColor,
          ),
        ),
        child: Center(
          child: Text(
            buttonTitle.toUpperCase(),
            style: TextStyle(
              color: mainColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildDefaultIconButton extends StatelessWidget {
  final Widget icon;
  final Function onClick;
  final double iconSize;

  const BuildDefaultIconButton(
      {@required this.icon, @required this.onClick, this.iconSize = 23.0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onClick,
      iconSize: iconSize,
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: mainColor.withOpacity(0.2),
    );
  }
}

class BuildDefaultCircleIconButton extends StatelessWidget {
  final IconData icon;
  final double radius, iconSize;
  final Function onClick;

  const BuildDefaultCircleIconButton(
      {@required this.onClick,
      @required this.icon,
      this.radius = 30.0,
      this.iconSize = 18.0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: mainColor.withOpacity(0.3),
      highlightColor: mainColor.withOpacity(0.3),
      icon: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: lightMainColor,
          shape: BoxShape.circle,
          border: Border.all(color: mainColor, width: 1.0),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18.0,
            color: mainColor,
          ),
        ),
      ),
      onPressed: onClick,
    );
  }
}

class BuildDefaultButton extends StatelessWidget {
  final String buttonName;
  final double height, width, borderRadiusValue;
  final Color buttonColor, buttonNameColor;
  final Function onClick;

  const BuildDefaultButton({
    @required this.buttonName,
    @required this.onClick,
    @required this.buttonNameColor,
    this.height = 40.0,
    this.width = double.infinity,
    this.borderRadiusValue = 8.0,
    this.buttonColor = mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      customBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: mainColor.withOpacity(0.2),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadiusValue),
          ),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: buttonNameColor,
                  fontSize: 16.0,
                ),
          ),
        ),
      ),
    );
  }
}

class BuildDefaultOutlinedButton extends StatelessWidget {
  final Widget buttonWidget;
  final double height, width, borderRadiusValue;
  final Function onClick;

  const BuildDefaultOutlinedButton({
    @required this.buttonWidget,
    @required this.onClick,
    this.height = 40.0,
    this.width = double.infinity,
    this.borderRadiusValue = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      onTap: onClick,
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: mainColor.withOpacity(0.2),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadiusValue),
          ),
          border: Border.all(color: greyColor),
        ),
        child: Center(child: buttonWidget),
      ),
    );
  }
}

class BuildDefaultTextButton extends StatelessWidget {
  final Function onClick;
  final String title;
  final Color buttonColor;
  final double textSize;

  const BuildDefaultTextButton(
      {@required this.onClick,
      @required this.title,
      @required this.buttonColor,
      this.textSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith(
            (states) => mainColor.withOpacity(0.1)),
      ),
      onPressed: onClick,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: buttonColor,
              fontSize: textSize,
            ),
      ),
    );
  }
}

class BuildCachedNetworkImage extends StatelessWidget {
  final String url;
  final double height, width;

  const BuildCachedNetworkImage(
      {@required this.url, this.height = 180.0, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => buildCircularLoadingWidget(),
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.error),
      ),
    );
  }
}

class BuildUserCircleImage extends StatelessWidget {
  final ImageProvider image;
  final double imageRadius;

  const BuildUserCircleImage(
      {@required this.image, @required this.imageRadius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: imageRadius,
      backgroundImage: image,
      backgroundColor: mainColor.withOpacity(0.5),
      foregroundColor: mainColor,
    );
  }
}

AppBar buildDefaultAppBar(
        {@required String title,
        double titleSpacing,
        Widget leading,
        List<Widget> actions}) =>
    AppBar(
      title: Text(
        title,
      ),
      titleSpacing: titleSpacing,
      leading: leading,
      actions: actions,
    );

Divider buildDefaultDivider({double height = 1.0}) {
  return Divider(
    color: greyColor,
    thickness: 1.0,
    height: height,
  );
}

class BuildWriteContentTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function onChange;

  const BuildWriteContentTextField(
      {@required this.controller, @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      keyboardType: TextInputType.text,
      autofocus: true,
      autocorrect: true,
      cursorColor: mainColor,
      style: const TextStyle(
        fontSize: 12.0,
        color: darkMainColor,
      ),
      decoration: const InputDecoration(
        contentPadding: const EdgeInsetsDirectional.only(start: 10.0),
        isDense: true,
        hintText: 'Write a comment...',
        hintStyle: TextStyle(
          color: mainColor,
          fontSize: 12.0,
          height: 1.2,
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

class BuildWriteContentWidget extends StatefulWidget {
  final TextEditingController contentController;
  final Function sendContent, pickContentImage;
  final File contentImage;

  const BuildWriteContentWidget(
      {@required this.contentController,
      @required this.sendContent,
      @required this.pickContentImage,
      @required this.contentImage});

  @override
  _BuildWriteContentWidgetState createState() =>
      _BuildWriteContentWidgetState();
}

class _BuildWriteContentWidgetState extends State<BuildWriteContentWidget> {
  String _textFieldContent = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildDefaultDivider(height: 0.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              InkWell(
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA7B6),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      IconBroken.Image,
                      size: 22.0,
                      color: mainColor,
                    ),
                  ),
                ),
                onTap: widget.pickContentImage,
              ),
              mediumHorizontalDistance(),
              Expanded(
                child: Container(
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA7B6),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BuildWriteContentTextField(
                          controller: widget.contentController,
                          onChange: (String value) {
                            setState(() {
                              _textFieldContent = value;
                            });
                          },
                        ),
                      ),
                      InkWell(
                        onTap: _textFieldContent == '' &&
                                widget.contentImage == null
                            ? () {}
                            : () {
                                widget.sendContent();
                                setState(() {
                                  _textFieldContent = '';
                                });
                              },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          color: mainColor,
                          child: Center(
                            child: Icon(
                              IconBroken.Send,
                              size: 22.0,
                              color: _textFieldContent == '' &&
                                      widget.contentImage == null
                                  ? Colors.grey
                                  : whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildErrorResultWidget extends StatelessWidget {
  final String errorImage, errorMessage;

  const BuildErrorResultWidget(
      {@required this.errorImage, @required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              errorImage,
              height: 350.0,
              width: 350.0,
              fit: BoxFit.fill,
            ),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildEmptyListWidget extends StatelessWidget {
  final String title;

  const BuildEmptyListWidget({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/noData.png',
              height: 220.0,
              width: 250.0,
              fit: BoxFit.fill,
            ),
            Text(
              'Opps !'.toUpperCase(),
              style: const TextStyle(color: mainColor, fontSize: 28.0),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: greyColor, fontWeight: FontWeight.normal, height: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPlatformRefreshIndicator extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final Future Function() onRefresh;
  final Widget child;

  BuildPlatformRefreshIndicator(
      {@required this.refreshKey,
      @required this.onRefresh,
      @required this.child});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget() : buildIosWidget();
  }

  Widget buildAndroidWidget() {
    return RefreshIndicator(
        key: refreshKey, child: child, onRefresh: onRefresh);
  }

  Widget buildIosWidget() {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          key: refreshKey,
          onRefresh: onRefresh,
        ),
        SliverToBoxAdapter(
          child: child,
        ),
      ],
    );
  }
}

Center buildCircularLoadingWidget() => const Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
    );

LinearProgressIndicator buildLinearLoadingWidget() =>
    const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(mainColor));

SizedBox mediumVerticalDistance() => const SizedBox(
      height: 10.0,
    );

SizedBox mediumHorizontalDistance() => const SizedBox(
      width: 10.0,
    );

SizedBox minimumHorizontalDistance() => const SizedBox(
      width: 5.0,
    );

SizedBox minimumVerticalDistance() => const SizedBox(
      height: 5.0,
    );

void namedNavigateTo(BuildContext context, String routeName, {arguments}) {
  Navigator.pushNamed(context, routeName, arguments: arguments);
}

void replacementNamedNavigateTo(BuildContext context, String routeName) {
  Navigator.pushReplacementNamed(context, routeName);
}

SnackBar buildDefaultSnackBar(context,
    {@required Key key, @required String contentText, String label}) {
  return SnackBar(
    key: key,
    backgroundColor: mainColor,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            contentText,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: whiteColor, fontWeight: FontWeight.normal),
          ),
        ),
        minimumHorizontalDistance(),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: Container(
            height: 30.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: whiteColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
              border: Border.all(color: whiteColor),
            ),
            child: Center(
              child: Text(
                label ?? 'ok',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: whiteColor, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void showToast(BuildContext context, String message) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}
