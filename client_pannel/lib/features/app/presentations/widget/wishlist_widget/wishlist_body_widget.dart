import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/features/app/presentations/widget/search_widget/barber_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../domain/entity/barber_entity.dart';
import '../../state/bloc/fetch_bloc/fetch_wishlist_bloc/fetch_wishlist_bloc.dart';
import '../search_widget/barber_custom_cards.dart';

class WishlistScreenWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const WishlistScreenWidget(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<WishlistScreenWidget> createState() => _WishlistScreenWidgetState();
}

class _WishlistScreenWidgetState extends State<WishlistScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchWishlistBloc>().add(FetchWishlistRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchWishlistBloc, FetchWishlistState>(
      builder: (context, state) {
        if (state is FetchWishlistLoading) {
          return SizedBox(
            height: widget.screenHeight * .7,
            child: LoadingScreen(
              screenHeight: widget.screenHeight,
              screenWidth: widget.screenWidth,
            ),
          );
        } else if (state is FetchWishlistEmpty) {
           return Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstantWidgets.hight50(context),
                Icon(Icons.heart_broken,color: AppPalette.redColor,size: 50,),
                Text("Something’s missing… maybe your favorites?"),
                Text('It’s time to turn intent into impact.')
              ],
                       ),
           );
        } 
         else if (state is FetchWishlistSuccess) {
          final List<BarberEntity> barbers = state.wishlists;

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: barbers.length,
            itemBuilder: (context, index) {
              final barber = barbers[index];
              return ListForBarbers(
                ontap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, AppRoutes.detailBarber, arguments: barber.uid);
                },
                screenHeight: widget.screenHeight,
                screenWidth: widget.screenWidth,
                imageURl: barber.image ?? AppImages.barberEmpty,
                rating: barber.rating,
                shopName: barber.ventureName,
                shopAddress: barber.address,
                isBlocked: barber.isBloc,
              );
            },
            separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
          );
        }

           return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Center( child:Icon(Icons.heart_broken,color: AppPalette.redColor,size: 50,)),
              Text("Looks like there was an issue."),
             Text("No results matched your request. Please try again."),
             IconButton(onPressed: (){
               context.read<FetchWishlistBloc>().add(FetchWishlistRequest());
             }, icon: Icon(Icons.refresh_rounded))
            ],
          );
      },
    );
  }
}
