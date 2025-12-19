// import 'package:flutter/material.dart';
import 'package:comp_vis_project/model_data.dart';

// Ambil semua warta terurut terbaru → terlama
List<Warta> getLatestToLongestWarta({int? limit}) {
  final sorted = List.of(dummyWarta)
    ..sort((a, b) => b.date.compareTo(a.date));

  if (limit != null && limit < sorted.length) {
    return sorted.take(limit).toList();
  }
  return sorted;
}

// Ambil semua warta terurut terlama → terbaru
List<Warta> getLongestToLatestWarta({int? limit}) {
  final sorted = List.of(dummyWarta)
    ..sort((a, b) => a.date.compareTo(b.date));

  if (limit != null && limit < sorted.length) {
    return sorted.take(limit).toList();
  }
  return sorted;
}

// Ambil semua sermons terurut terbaru → terlama
List<Sermon> getLatestToLongestSermons({int? limit}) {
  final sorted = List.of(dummySermons)
    ..sort((a, b) => b.date.compareTo(a.date));

  if (limit != null && limit < sorted.length) {
    return sorted.take(limit).toList();
  }
  return sorted;
}

// Ambil semua sermons terurut terlama → terbaru
List<Sermon> getLongestToLatestSermons({int? limit}) {
  final sorted = List.of(dummySermons)
    ..sort((a, b) => a.date.compareTo(b.date));

  if (limit != null && limit < sorted.length) {
    return sorted.take(limit).toList();
  }
  return sorted;
}
