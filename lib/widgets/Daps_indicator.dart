import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrl_2026/widgets/tms_normaltext.dart';

import 'app_size.dart';

// class ColorCirclesWidget extends StatelessWidget {
//    RxBool red = false.obs;
//    RxBool yellow = false.obs;
//    RxBool green = false.obs;
//    RxBool blue = false.obs;
//
//    ColorCirclesWidget({
//     super.key,
//     required this.red,
//     required this.yellow,
//     required this.green,
//     required this.blue,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Stack(
//         children: [
//           if (red.value)
//             const Positioned(
//               right: 0,
//               child: CircleAvatar(
//                 backgroundColor: Colors.red,
//                 radius: 8,
//               ),
//             ),
//           if (yellow.value)
//             Positioned(
//               right: red.value ? 10 : 0,
//               child: const CircleAvatar(
//                 backgroundColor: Colors.green,
//                 radius: 8,
//               ),
//             ),
//           if (green.value)
//             Positioned(
//               right: yellow.value
//                   ? red.value
//                       ? 20
//                       : 10
//                   : red.value
//                       ? 10
//                       : 0,
//               child: const CircleAvatar(
//                 backgroundColor: Colors.blueAccent,
//                 radius: 8,
//               ),
//             ),
//           if (blue.value)
//             Positioned(
//               right: green.value? yellow.value? red.value ? 30: 20: 20 : yellow.value ? 20: red.value? 10: 0,
//               child: const CircleAvatar(
//                 backgroundColor: Colors.orange,
//                 radius: 8,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
class ColorCirclesWidget extends StatelessWidget {
  RxBool red = false.obs;
  RxBool yellow = false.obs;
  RxBool green = false.obs;
  RxBool blue = false.obs;

  RxString redText = ''.obs;
  RxString yellowText = ''.obs;
  RxString greenText = ''.obs;
  RxString blueText = ''.obs;

  ColorCirclesWidget({
    super.key,
    required this.red,
    required this.redText,
    required this.yellow,
    required this.yellowText,
    required this.green,
    required this.greenText,
    required this.blue,
    required this.blueText,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          if (red.value) ...{
            BoxDesign(
              context,
              color: Colors.red,
              text: redText.value,
            )
          } else ...{
            BoxDesign(
              context,
              color: Colors.grey,
              text: redText.value,
            )
          },
          if (blue.value) ...{
            BoxDesign(
              context,
              color: Color(0xff0500E3),
              text: blueText.value,
            )
          } else ...{
            BoxDesign(
              context,
              color: Colors.grey,
              text: blueText.value,
            )
          },
          // if (yellow.value) ...{
          //   BoxDesign(
          //     context,
          //     color: Colors.yellow,
          //     text: yellowText.value,
          //   )
          // } else ...{
          //   BoxDesign(
          //     context,
          //     color: Colors.grey,
          //     text: yellowText.value,
          //   )
          // },
          // if (green.value) ...{
          //   BoxDesign(
          //     context,
          //     color: Colors.green,
          //     text: greenText.value,
          //   )
          // } else ...{
          //   BoxDesign(
          //     context,
          //     color: Colors.grey,
          //     text: greenText.value,
          //   )
          // },
        ],
      ),
    );
  }

  BoxDesign(BuildContext context,
      {required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
      child: Column(
        children: [
          Container(
            height: AppSize.size(context).height * 0.009,
            width: AppSize.size(context).width * 0.12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TmsText(
              text: text,
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}