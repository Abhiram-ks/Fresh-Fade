import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_colors.dart';

// class BarbersStatusBuilder extends StatelessWidget {
//   final double screenHeight;
//   final double screenWidth;

//   const BarbersStatusBuilder(
//       {super.key, required this.screenHeight, required this.screenWidth});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<BarberstatusBloc, BarberstatusState>(
//       listener: (context, state) {
//         handStatusResponseState(context, state);
//       },
//       child: BlocBuilder<FetchBarbersBloc, FetchBarbersState>(
//         builder: (context, state) {
//           if (state is FetchBarbersInitial) {
//             return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SpinKitCircle(color: AppPalette.mainClr),
//                 ConstantWidgets.hight10(context),
//                 Text('Just a moment...'),
//                 Text('Please wait while we process your request'),
//               ],
//             ),
//           );
//           }
//           else if (state is BarberEmptyState) {
//                      return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   LottiefilesCommon(
//                       assetPath: AppLottieImages.emptyData,
//                       width: screenWidth * .3,
//                       height: screenHeight * .3),
//                   Text("Oops! There's nothing here yet."),
//                 Text('No services added yet — time to take action!'),
//                 ],
//               ),
//             );
//           } 
//           else if (state is BarberLoadedState) {
//             final registedBarbers = state.barbers
//                 .where((barber) => barber.isVerified == true)
//                 .toList();

//             if (registedBarbers.isEmpty) {
//                      return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   LottiefilesCommon(
//                       assetPath: AppLottieImages.emptyData,
//                       width: screenWidth * .3,
//                       height: screenHeight * .3),
//                   Text("Oops! There's nothing here yet.",style: TextStyle(fontWeight: FontWeight.bold),),
//                 Text('No services added yet — time to take action!'),
//                 ],
//               ),
//             );
//             }
//             return ListView.separated(
//               itemCount: registedBarbers.length,
//               itemBuilder: (context, index) {
//                 final barber = registedBarbers[index];
//                 return RequestCardWidget(
//                   screenHeight: screenHeight,
//                   screenWidth: screenWidth,
//                   barbername: barber.barberName,
//                   emailId: barber.email,
//                   phoneNumber: barber.phoneNumber,
//                   address: barber.address,
//                   postive: 'UnBlock',
//                   onPostive: () {
//                     if (barber.isBlocked) {
//                       context
//                           .read<BarberstatusBloc>()
//                           .add(ShowUnblockAlert(uid: barber.uid));
//                     } else {
//                       CustomeSnackBar.show(
//                         context: context,
//                         title: 'Barber Already Active',
//                         description:
//                             'The barber ${barber.barberName} is already active. Unblock is not required.',
//                         iconColor: AppPalette.greenClr,
//                         icon: CupertinoIcons.check_mark_circled,
//                       );
//                     }
//                   },
//                   negative: 'Block',
//                   onNegative: () {
//                     if (barber.isBlocked) {
//                       CustomeSnackBar.show(
//                         context: context,
//                         title: 'Barber Already Blocked',
//                         description: 'The barber ${barber.barberName} is already blocked. No further action is required as blocking has already been performed.',
//                           iconColor: AppPalette.redClr,
//                        icon: CupertinoIcons.hand_raised_fill,
//                       );
//                     } else {
//                        context.read<BarberstatusBloc>().add(ShowBlockAlert(uid: barber.uid));
//                     }
//                   },
//                   imagePath:barber.image ?? '',
//                   isBlock: barber.isBlocked,
//                 );
//               },
//               separatorBuilder: (context, index) => SizedBox(
//                 height: 6,
//               ),
//             );
//           } 
//                     return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(Icons.cloud_off_outlined,color: AppPalette.blackColor,size:  50,),
//               Text("Oop's Unable to complete the request."),
//               Text('Please try again later.'),
//               IconButton(onPressed: (){
//                 context.read<FetchBarbersBloc>().add(FetchBarbersDataEvent());
//               }, 
//               icon: Icon(Icons.refresh_rounded))
//             ],
//           ),
//         );

           
//         },
//       ),
//     );
//   }
// }
