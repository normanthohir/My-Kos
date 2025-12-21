import 'package:flutter/material.dart';

class ReportData {
  final String period;
  final int totalRooms;
  final int occupiedRooms;
  final int availableRooms;
  final int activeResidents;
  final int checkoutResidents;
  final double totalIncome;
  final double averageOccupancy;
  final List<MonthlyData> monthlyData;
  final List<TopRoom> topRooms;
  final List<RecentActivity> recentActivities;

  ReportData({
    required this.period,
    required this.totalRooms,
    required this.occupiedRooms,
    required this.availableRooms,
    required this.activeResidents,
    required this.checkoutResidents,
    required this.totalIncome,
    required this.averageOccupancy,
    required this.monthlyData,
    required this.topRooms,
    required this.recentActivities,
  });
}

class MonthlyData {
  final String month;
  final double income;
  final int occupancy;

  MonthlyData({
    required this.month,
    required this.income,
    required this.occupancy,
  });
}

class TopRoom {
  final String roomNumber;
  final String roomType;
  final double income;
  final int occupancyDays;

  TopRoom({
    required this.roomNumber,
    required this.roomType,
    required this.income,
    required this.occupancyDays,
  });
}

class RecentActivity {
  final String activity;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  RecentActivity({
    required this.activity,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}
