import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:memory_map/pages/images_page.dart';
import 'package:memory_map/providers/location_provider.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

class ARViewScreen extends StatefulWidget {
  @override
  _ARViewScreenState createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  
  ARNode? node;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('AR Object Interaction')),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      ARAnchorManager anchorManager,
      ARLocationManager locationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Initialize AR session
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      showAnimatedGuide: false,
    );

    // Set the node tap callback
    arObjectManager!.onNodeTap = onNodeTapped;

    // Add the object
    addObject();
  }

  Future<void> addObject() async {
    if (arObjectManager != null) {
      node = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/heisenberg33333/3d-ar-model/raw/refs/heads/main/map_pointer_places_of_interest.glb",
        scale: Vector3(1.0, 1.0, 1.0),
        position: Vector3(0.0, 0.0, -2.0),
      );

      bool? didAddNode = await arObjectManager!.addNode(node!);
      if (didAddNode == true) {
        debugPrint("Node added successfully.");
      } else {
        debugPrint("Failed to add node.");
      }
    }
  }

  void onNodeTapped(List<String> nodes) {
    if (nodes.isNotEmpty) {
      Provider.of<MarkerProvider>(context, listen: false).updateViewed(context.read<LocationProvider>().index);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagesPage(index: context.read<LocationProvider>().index)));
    }
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}
