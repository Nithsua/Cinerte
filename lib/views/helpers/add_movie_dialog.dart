import 'dart:io';

import 'package:cinerte/models/movie_model.dart';
import 'package:cinerte/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMovieDialog extends StatefulWidget {
  const AddMovieDialog({Key? key}) : super(key: key);

  @override
  _AddMovieDialogState createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  final _movieTitleController = TextEditingController();
  final _directorNameController = TextEditingController();
  XFile? imageRef;

  bool _isFormatValid = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: Theme.of(context).cardTheme.shape,
      backgroundColor: Theme.of(context).backgroundColor,
      title: const Text("Add Movie to Catelog"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                onChanged: (_) {
                  setState(() {
                    _directorNameController.text.isNotEmpty &&
                            _movieTitleController.text.isNotEmpty &&
                            imageRef != null
                        ? _isFormatValid = true
                        : _isFormatValid = false;
                  });
                },
                controller: _movieTitleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Movie Title"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                onChanged: (_) {
                  setState(() {
                    _directorNameController.text.isNotEmpty &&
                            _movieTitleController.text.isNotEmpty &&
                            imageRef != null
                        ? _isFormatValid = true
                        : _isFormatValid = false;
                  });
                },
                controller: _directorNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Director Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextButton(
                          onPressed: () async {
                            imageRef = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              _directorNameController.text.isNotEmpty &&
                                      _movieTitleController.text.isNotEmpty &&
                                      imageRef != null
                                  ? _isFormatValid = true
                                  : _isFormatValid = false;
                            });
                          },
                          child: const Text("Add Banner"))),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: _isFormatValid
                ? () async {
                    try {
                      Navigator.pop(context);
                      await firestoreServices.writeCollection("movies", {
                        "movieTitle": _movieTitleController.text,
                        "directorName": _directorNameController.text,
                        "imgRef": await cloudStorageServices
                            .uploadFile(File(imageRef!.path)),
                        // "imgRef": "",
                      });

                      // ScaffoldMessenger.of(context).showMaterialBanner(
                      //   MaterialBanner(
                      //     content: const Text('Movie Added'),
                      //     leading: const Icon(Icons.info),
                      //     backgroundColor: Theme.of(context).cardColor,
                      //     actions: [
                      //       TextButton(
                      //         child: const Text('Dismiss'),
                      //         onPressed: () => ScaffoldMessenger.of(context)
                      //             .hideCurrentMaterialBanner(),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              shape: Theme.of(context).cardTheme.shape,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: const Text("Oops, Something happened"),
                              content: const Text("try again later"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Ok"))
                              ],
                            );
                          });
                    }

                    Provider.of<MovieModel>(context, listen: false).refresh();
                  }
                : null,
            child: const Text("Ok")),
      ],
    );
  }
}
