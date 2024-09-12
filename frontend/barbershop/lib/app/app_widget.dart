import "package:barbershop/app/data/auth/auth.dart";
import "package:barbershop/app/data/auth/auth_check.dart";
import "package:barbershop/app/data/model/barbershop_model.dart";
import "package:barbershop/app/data/repositories/babershop_service_repository.dart";
import "package:barbershop/app/data/repositories/barber_best_rated_repository.dart";
import "package:barbershop/app/data/repositories/barbershop_barber_repository.dart";
import "package:barbershop/app/data/repositories/barbershop_repository.dart";
import "package:barbershop/app/data/repositories/booking_repository.dart";
import "package:barbershop/app/data/repositories/slots_repository.dart";
import 'package:barbershop/app/data/http/http_client.dart';
import "package:barbershop/app/data/repositories/user_repository.dart";
import "package:barbershop/app/pages/barbershop/barbershop_page.dart";
import "package:barbershop/app/pages/booking/booking_page.dart";
import "package:barbershop/app/pages/booking/booking_store.dart";
import "package:barbershop/app/pages/details/barber_details.dart";
import "package:barbershop/app/pages/details/barber_store.dart";
import "package:barbershop/app/pages/details/details.store.dart";
import "package:barbershop/app/pages/details/slots_store.dart";
import "package:barbershop/app/pages/home/barbershop_store.dart";
import "package:barbershop/app/pages/home/best_rated_barber_store.dart";
import "package:barbershop/app/pages/home/home_page.dart";
import "package:barbershop/app/pages/login/login_page.dart";
import "package:barbershop/app/pages/register/register_page.dart";
import 'package:barbershop/app/pages/details/details_page.dart';
import "package:barbershop/app/pages/user-profile/user_profile.dart";
import "package:barbershop/app/pages/user-profile/user_store.dart";
import "package:barbershop/app/utils/routes.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => BarbershopStore(
            repository: BarbershopRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailsStore(
            repository: BarbershopServiceRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingStore(
            BookingRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SlotsStore(
            repository: SlotsRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserStore(
            repository: UserRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BarberStore(
            repository: BarbershopBarberRepository(
              client: HttpClient(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BestRatedBarberStore(
            repository: BarberBestRatedRepository(
              client: HttpClient(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        locale: const Locale("pt", "BR"),
        title: "Barbershop Ballan'aibs",
        home: const AuthCheck(),
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.homePage: (context) => HomePage(
                userData: const {},
              ),
          Routes.loginPage: (context) => const LoginPage(),
          Routes.registerPage: (context) => const RegisterPage(),
          Routes.detailsPage: (context) => DetailsPage(
              userData: const {},
              barbershop: ModalRoute.of(context)!.settings.arguments
                  as BarbershopModel),
          Routes.bookingPage: (context) =>
              const BookingPage(userData: {}, barbershopData: {}),
          Routes.barbershopPage: (context) => const BarbershopPage(),
          Routes.userProfile: (context) => const UserProfile(),
          Routes.barberDetails: (context) =>
              BarberDetails(barber: {}, barbershop: {} as BarbershopModel),
        },
      ),
    );
  }
}
