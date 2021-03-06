import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_toast/tbib_toast.dart';
import 'package:zhelper/ui/screens/login_screen/login_screen.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../../shared/helper/methods.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../cubit/register_state.dart';
import '../cubit/regsiter_cubit.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoadingState)
            showCustomProgressIndicator(context);
          else if (state is RegisterSuccessCreateState) {
            Navigator.pop(context);
            Toast.show("Success Create Account", context,
                backgroundColor: Colors.green, duration: 3);
            navigateToAndFinish(context, LoginScreen());
          } else if (state is RegisterSuccessNotCreatedCreateState) {
            Navigator.pop(context);
            Toast.show("${state.msg}", context,
                backgroundColor: Colors.red, duration: 3);
          } else if (state is RegisterFailuerState) {
            print(state.errorMsg);
            Navigator.pop(context);
            Toast.show("Error In Server", context,
                backgroundColor: Colors.red, duration: 3);
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomTextFormField(
                      controller: userNameController,
                      lableText: '?????? ????????????????',
                      validate: (value) {
                        if (value.isEmpty) {
                          return '?????? ???????????????? ??????????';
                        }
                      },
                      type: TextInputType.text,
                      prefixIcon: 'assets/icons/User.svg'),
                ),
                SizedBox(
                  height: SizeConfigManger.bodyHeight * 0.03,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomTextFormField(
                      controller: ageController,
                      lableText: '??????????',
                      validate: (value) {
                        if (value.isEmpty) {
                          return '?????????? ??????????';
                        }
                      },
                      type: TextInputType.number,
                      prefixIcon: 'assets/icons/User.svg'),
                ),
                SizedBox(
                  height: SizeConfigManger.bodyHeight * 0.03,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomTextFormField(
                      controller: emailController,
                      lableText: '??????????????',
                      validate: (value) {
                        if (value.isEmpty) {
                          return '???????????? ???????????????????? ??????????';
                        }
                      },
                      type: TextInputType.emailAddress,
                      prefixIcon: 'assets/icons/User.svg'),
                ),
                SizedBox(
                  height: SizeConfigManger.bodyHeight * 0.03,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomTextFormField(
                    isPassword: true,
                    controller: passwordController,
                    validate: (value) {
                      if (value.isEmpty) {
                        return '???????? ???????????? ????????????';
                      }
                    },
                    type: TextInputType.visiblePassword,
                    lableText: '???????? ????????',
                    prefixIcon: 'assets/icons/Lock.svg',
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                CustomButton(
                    textColor: Colors.white,
                    text: "?????????? ???????? ????????",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        int age = int.parse(ageController.text);
                        if (age < 18) {
                          Toast.show("???????? ???? ???????? ?????????? 18 ??????", context);
                        } else {
                          cubit.regiterNewUser(
                              email: emailController.text,
                              password: passwordController.text,
                              age: int.parse(ageController.text),
                              username: userNameController.text);
                        }
                      }
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
