import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/l10n/l10n.dart';
import 'package:speed_reader/pages/reading_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadingBloc>(
      create: (context) =>
          ReadingBloc()..add(ReadingEvent.update(words: text.split(' '))),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(
              appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: const Color(0xFF13B9FF),
              ),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ReadingListPage(),
          );
        },
      ),
    );
  }
}

const text = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at sollicitudin urna, ullamcorper sodales nisl. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis ut ipsum a nisl sagittis vehicula eget non augue. Sed sed sagittis justo, sed fermentum justo. In suscipit eu lorem quis placerat. Curabitur vitae porttitor tellus. Nullam nec diam id felis gravida hendrerit vel id turpis. Sed viverra, elit eu venenatis faucibus, enim libero sollicitudin tellus, viverra consectetur neque elit non metus. Vivamus posuere eleifend sem in convallis.

Nulla ornare urna nibh, in mollis mauris efficitur sed. Aliquam gravida consequat porttitor. Proin cursus imperdiet nunc ut accumsan. Quisque dui nibh, consequat a turpis at, egestas viverra lorem. Sed quam nibh, porttitor vel neque a, sodales ultricies elit. Pellentesque vel interdum enim, vitae lacinia nunc. Vestibulum ultrices, nibh et dapibus semper, nulla sem ornare ipsum, nec facilisis nulla erat eu dolor. Fusce efficitur posuere vestibulum. Pellentesque consequat congue massa, quis pharetra turpis consectetur sit amet. Aliquam et sem ut odio vehicula porta. Suspendisse potenti. Donec nec tincidunt eros.

Suspendisse potenti. Donec eu sapien et nisi feugiat ultrices. Sed eu tellus sagittis, venenatis ipsum ac, porttitor neque. Cras eget lacus ac sapien lacinia vulputate ac ac arcu. Interdum et malesuada fames ac ante ipsum primis in faucibus. Vestibulum convallis magna sit amet sem interdum euismod. Aenean ut ante hendrerit, egestas tellus id, condimentum nunc. Nam viverra semper purus, non facilisis purus viverra eu.

Sed sed fermentum massa, sed pulvinar dui. Sed pharetra risus vel turpis maximus posuere. Ut tortor odio, egestas ut dictum non, dapibus sit amet ex. Maecenas nec aliquam diam. Nunc efficitur magna eu justo convallis dapibus. Integer ut rutrum elit. Nam in augue scelerisque mi porttitor convallis ac non ex. Suspendisse scelerisque ante ut faucibus molestie. Nullam ultrices tristique eros quis tempor. Phasellus ornare turpis non mi finibus imperdiet. Phasellus sed tempor nisl. Quisque ante arcu, interdum sit amet ipsum a, dapibus venenatis lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus efficitur orci et auctor vestibulum. Vestibulum vel metus commodo, lobortis ex non, ultrices turpis.

Donec a sem scelerisque, rutrum purus in, placerat odio. Curabitur fermentum sem vel tincidunt vulputate. Cras vitae elit vitae leo consequat malesuada eget et magna. Integer at elit nibh. Pellentesque mattis suscipit magna ut scelerisque. Proin a enim lectus. Ut sed ex efficitur leo imperdiet consequat. Cras tincidunt ornare ipsum, id porta risus aliquet eu. Cras sit amet gravida risus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut faucibus scelerisque justo sed efficitur.

Proin pharetra viverra purus, vel luctus nunc semper quis. Mauris convallis ornare elit, vitae rutrum libero posuere vitae. Integer a ipsum odio. Curabitur eleifend hendrerit viverra. Donec vel faucibus felis, eu egestas ipsum. Phasellus dictum metus ac nunc vestibulum tincidunt eu ut tortor. Praesent faucibus ligula est, quis dapibus urna egestas a. Sed tristique sit amet urna et aliquam. Fusce porttitor elementum ornare. Nulla malesuada pulvinar placerat. Phasellus in maximus ante. Fusce malesuada iaculis porttitor.''';
