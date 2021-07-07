import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivs_maintenance_2/models/tech.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/models/town_problem.dart';

/* Class where we communicate with the backend. We provide this in our 
main.dart, which allows our front end to make calls using
Provider.of<DatabaseService>. Could possibly look into splitting this into
multiple files. */
class DatabaseService {
  /* References we can use to query the collections in firestore */
  CollectionReference townsRef = FirebaseFirestore.instance.collection('towns');
  CollectionReference techsRef = FirebaseFirestore.instance.collection('techs');

  /* Gets future of single town by id */
  Future<Town> getTownById(String townId) async =>
      Town.fromDoc(await townsRef.doc(townId).get());

  Future<Tech> getTechById(String techId) async =>
      Tech.fromDoc(await techsRef.doc(techId).get());

  /* Updates systemsServiced and notes in firestore for town with townId.
  Returns true if successful, false if error. */
  Future<bool> submitTownReport(String townId, int systemsServiced,
      String notes, DateTime timeSubmitted) async {
    print(systemsServiced);
    try {
      Town currTown = Town.fromDoc(await townsRef.doc(townId).get());
      /* if first time submitting, set finishTime */
      if (!currTown.completed) {
        await townsRef.doc(townId).update({
          'finishTime': Timestamp.fromDate(timeSubmitted),
        });
      }
      await townsRef.doc(townId).update({
        'systemsServiced': systemsServiced,
        'techNotes': notes,
        'completed': true,
      });
      return true;
    } catch (e) {
      log(e.toString());
      print('Error with submitting town report: $e');
      return false;
    }
  }

  /* Submits admin edit town form and updates town in backend. Returns true
  if successful, false if error */
  Future<bool> submitAdminEditTown(
      {required String townId,
      required int numMachines,
      required String contacts,
      required String address,
      required String parkingNotes,
      required String buildingNotes,
      required String phoneNumbers,
      required DateTime scheduledTime,
      required String assignedTeam}) async {
    try {
      await townsRef.doc(townId).update({
        'numMachines': numMachines,
        'contacts': contacts,
        'address': address,
        'parkingNotes': parkingNotes,
        'buildingNotes': buildingNotes,
        'phoneNumbers': phoneNumbers,
        'scheduledTime': scheduledTime,
        'assignedTeam': assignedTeam,
      });
      return true;
    } catch (e) {
      log(e.toString());
      print('Error with submitting admin edit town report: $e');
      return false;
    }
  }

  /* Gets a stream of a town's problems. Maps Querysnapshots of the entire 
  collection, and then maps each of those snapshots' documents to a list of 
  TownProblem objects */
  Stream<List<TownProblem>> getTownProblemsStream(String townId) => townsRef
      .doc(townId)
      .collection('problems')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => TownProblem.fromDoc(doc),
          )
          .toList());

  // Stream<List<Town>> getCurrentDayStream(
  //         DateTime dayStart, DateTime dayEnd, String team) =>
  //     townsRef
  //         .where('scheduledTime', isGreaterThanOrEqualTo: dayStart)
  //         .where('scheduledTime', isLessThanOrEqualTo: dayEnd)
  //         .where('assignedTeam', isEqualTo: team)
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs
  //             .map(
  //               (doc) => Town.fromDoc(doc),
  //             )
  //             .toList());

  /* Gets a stream of all techs. */
  Stream<List<Tech>> getAllTechsStream() => techsRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Tech.fromDoc(doc)).toList());

  /* Adds a problem to town with townId's problems subcollection in firestore. 
  Returns new problem id if successful, null if error */
  Future<String?> addProblemToTown(
      {required String townId,
      required String itemName,
      required int replaced,
      required int unresolved}) async {
    try {
      /* Make problem in problems subcollection */
      DocumentReference newProb =
          await townsRef.doc(townId).collection('problems').add({
        'itemName': itemName,
        'replaced': replaced,
        'unresolved': unresolved,
      });
      /* Increment numUnresolvedItems in town document */
      if (unresolved > 0) {
        await townsRef
            .doc(townId)
            .update({"numUnresolvedItems": FieldValue.increment(unresolved)});
      }
      return newProb.id;
    } catch (e) {
      log(e.toString());
      print('Error with adding problem to town: $e');
    }
  }

  /* Removes the problem with problemId from the town with townId's problems 
  subcollection in firestore. Returns true if successful, false if error. */
  Future<bool> removeProblemFromTown(
      {required String townId, required String problemId}) async {
    try {
      /* Fetch problem doc in order to update numUnresolvedItems in town document */
      DocumentSnapshot problemDoc = await townsRef
          .doc(townId)
          .collection('problems')
          .doc(problemId)
          .get();
      TownProblem prob = TownProblem.fromDoc(problemDoc);
      if (prob.unresolved > 0) {
        await townsRef.doc(townId).update(
            {"numUnresolvedItems": FieldValue.increment(-prob.unresolved)});
      }
      /* Delete problem from subcollection */
      await townsRef.doc(townId).collection('problems').doc(problemId).delete();
      return true;
    } catch (e) {
      log(e.toString());
      print('Error with removing problem from town: $e');
      return false;
    }
  }

  /* Marks town as started in backend. Returns true if successful, false
  if error. */
  Future<bool> markTownAsStarted({required String townId}) async {
    try {
      await townsRef.doc(townId).update({'actualStartTime': DateTime.now()});
      return true;
    } catch (e) {
      log(e.toString());
      print('Error with marking town as started: $e');
      return false;
    }
  }

  /* Gets the stream of all towns */
  Stream<List<Town>> getAllTownsStream() =>
      townsRef.snapshots().map((snapshot) => snapshot.docs
          .map(
            (doc) => Town.fromDoc(doc),
          )
          .toList());

  /* Gets future of all towns */
  Future<List<Town>> getAllTownsFuture() async {
    try {
      QuerySnapshot townsSnap = await townsRef.get();
      return townsSnap.docs.map((doc) => Town.fromDoc(doc)).toList();
    } catch (e) {
      log(e.toString());
      print('Error with getting all towns future: $e');
      return [];
    }
  }

  /* Gets future of all team names */
  Future<List<String>> getAllTeamNames() async {
    try {
      QuerySnapshot townsSnap = await townsRef.get();
      List<Town> allTowns =
          townsSnap.docs.map((doc) => Town.fromDoc(doc)).toList();
      List<String> allTeams = [];
      allTowns.forEach((Town t) {
        if (!allTeams.contains(t.assignedTeam)) {
          allTeams.add(t.assignedTeam);
        }
      });
      return allTeams;
    } catch (e) {
      log(e.toString());
      print('Error with getting team names: $e');
      return [];
    }
  }

  /* Delete a town from backend */
  Future<void> deleteTown(String townId) async {
    try {
      await townsRef.doc(townId).delete();
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Get number of unresolved problems associated with town */
  Future<int> getNumUnresolvedProblems(String townId) async {
    try {
      QuerySnapshot townProbsSnap = await townsRef
          .doc(townId)
          .collection('problems')
          .where('unresolved', isGreaterThan: 0)
          .get();
      List<TownProblem> townProbs =
          townProbsSnap.docs.map((doc) => TownProblem.fromDoc(doc)).toList();
      int result = 0;
      townProbs.forEach((element) {
        result += element.unresolved;
      });
      return result;
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Deletes all towns from firestore */
  Future<void> clearAllTowns() async {
    try {
      QuerySnapshot townsSnap = await townsRef.get();
      townsSnap.docs.forEach((doc) {
        doc.reference.delete();
      });
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Add town to firestore. Returns id */
  Future<String> addTown({
    required String name,
    required int numMachines,
    required String address,
    required String contacts,
    required String parkingNotes,
    required String buildingNotes,
    required String phoneNumbers,
    required String assignedTeam,
    required DateTime scheduledTime,
  }) async {
    try {
      DocumentReference docRef = await townsRef.add({
        "name": name,
        "numMachines": numMachines,
        "address": address,
        "contacts": contacts,
        "parkingNotes": parkingNotes,
        "buildingNotes": buildingNotes,
        "phoneNumbers": phoneNumbers,
        "assignedTeam": assignedTeam,
        "scheduledTime": scheduledTime,
      });
      return docRef.id;
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }
}
