import 'package:flutter/material.dart';

class JoinPageSplit extends StatefulWidget {
  @override
  _JoinPageSplitState createState() => _JoinPageSplitState();
}

class _JoinPageSplitState extends State<JoinPageSplit> {
  double _buttonHeight = 70;
  double _marginHeight = 30;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                "Schuul을 이용해주셔서 감사합니다!어떤 역할을 맡고 계세요?",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: _marginHeight,
          ),
          SizedBox(
              height: _buttonHeight,
              width: size.width * 0.8,
              child: RaisedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InputEmailPw("강사"))),
                child: Text("저는 강사(관리자)입니다."),
              )),
          Container(
            height: _marginHeight,
          ),
          SizedBox(
              height: _buttonHeight,
              width: size.width * 0.8,
              child: RaisedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InputEmailPw("학생"))),
                child: Text("저는 학(출석자)입니다."),
              )),
          Container(
            height: _marginHeight * 5,
          ),
        ],
      ),
    );
  }
}

class InputEmailPw extends StatefulWidget {
  String _who;
  InputEmailPw(this._who);
  @override
  _InputEmailPwState createState() => _InputEmailPwState(_who);
}

class _InputEmailPwState extends State<InputEmailPw> {

  String _who;
  _InputEmailPwState(this._who);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode;
  FocusNode pwFocusNode;
  FocusNode cpwFocusNode;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController pwTextEditingController = TextEditingController();
  TextEditingController cpwTextEditingController = TextEditingController();

  @override
  void initState() {
    emailFocusNode = FocusNode();
    pwFocusNode = FocusNode();
    cpwFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입 - $_who"),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: 30, left: size.width * 0.1, right: size.width * 0.1),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                      hintText: "example@mail.com", labelText: "email"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    _fieldFocusChanged(
                        _formKey.currentContext, emailFocusNode, pwFocusNode);
                  },
                  controller: emailTextEditingController,
                ),
                TextFormField(
                  focusNode: pwFocusNode,
                  decoration: InputDecoration(
                      hintText: "password", labelText: "password"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    _fieldFocusChanged(
                        _formKey.currentContext, pwFocusNode, cpwFocusNode);
                  },
                  controller: pwTextEditingController,
                ),
                TextFormField(
                  focusNode: cpwFocusNode,
                  decoration: InputDecoration(
                      hintText: "confirm password",
                      labelText: "confirm password"),
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  onFieldSubmitted: (value) {
                    cpwFocusNode.unfocus();
                  },
                  controller: cpwTextEditingController,
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () =>
            FocusScope.of(_formKey.currentContext).requestFocus(pwFocusNode),
      ),
    );
  }

  void _fieldFocusChanged(BuildContext currentContext, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
