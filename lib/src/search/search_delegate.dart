import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
    'Capitan America',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Son las acciones de nuestro AppBar.
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar.
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar.
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando el usuario escribe.
    return (query.isEmpty)
        ? Container()
        : FutureBuilder(
            future: peliculasProvider.getBuscarPelicula(query),
            builder:
                (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
              return (!snapshot.hasData)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: snapshot.data.map((pelicula) {
                        return ListTile(
                          leading: FadeInImage(
                            image: NetworkImage(pelicula.getPosterImg()),
                            placeholder: AssetImage('assets/img/no-image.jpg'),
                            width: 50.0,
                            fit: BoxFit.contain,
                          ),
                          title: Text(pelicula.title),
                          subtitle: Text(pelicula.originalTitle),
                          onTap: () {
                            close(context, null);
                            pelicula.uniqueId = '';
                            Navigator.pushNamed(context, 'detalle',
                                arguments: pelicula);
                          },
                        );
                      }).toList(),
                    );
            },
          );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando el usuario escribe.
  //   final listaSugerida = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas
  //           .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: () {
  //           seleccion = listaSugerida[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
}
