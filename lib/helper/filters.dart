import 'package:luminarc/Models/filter_model.dart';


class Filters{

  List<Filter> list(){
    return <Filter>[
      Filter(
        'No Filter',
         [1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0 ] 
      ),
      Filter(
        'Purple',
         [1, -0.2, 0, 0, 0,
          0, 1, 0, -0.1, 0,
          0, 1.2, 1, 0.1, 0,
          0, 0, 1.7, 1, 0 ] 
      ),
      Filter(
        'Yellow',
         [1, 0, 0, 0, 0,
          -0.2, 1.0, 0.3, 0.1, 0,
          -0.1, 0, 1, 0, 0,
          0, 0, 0, 1, 0 ] 
      ),
      Filter(
        'cyan',
         [1.0, 0.0, 0.0, 1.9, -2.2,
          0.0, 1.0, 0.0, 0.0, 0.3,
          0.0, 0.0, 1.0, 0.0, 0.5,
          0.0, 0.0, 0.0, 1.0, 0.2 ] 
      ),
      Filter(
        'B&W',
         [0, 1, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 1, 0, 1, 0 ] 
      ),
      Filter(
        'Old times',
         [1, 0, 0, 0, 0,
          -0.4, 1.3, -0.4, 0.2, -0.1,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0 ] 
      ),
      Filter(
        'ColdLife',
         [1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          -0.2, 0.2, 0.1, 0.4, 0,
          0, 0, 0, 1, 0 ] 
      ),
      Filter(
        'Sepium',
         [1.3, -0.3, 1.1, 0, 0,
          0, 1.3, 0.2, 0, 0,
          0, 0, 0.8, 0.2, 0,
          0, 0, 0, 1, 0 ] 
      ),
      Filter(
        'Milk',
         [1.0, 0, 0, 0, 0,
          0, 1.0, 0, 0, 0,
          0, 0.6, 1, 0, 0,
          0, 0, 0, 1, 0 ] 
      ),


    ];
  }

}