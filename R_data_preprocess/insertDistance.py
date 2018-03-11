# -*- coding:UTF-8 -*-

import os
import csv
import math


def distance(lat0, lon0, lat1, lon1):
    R = 6373.0

    lat0 = float(lat0)
    lon0 = float(lon0)
    lat1 = float(lat1)
    lon1 = float(lon1)

    dlon = lon1 - lon0
    dlat = lat1 - lat0

    a = math.sin(dlat / 2)**2 + math.cos(lat0) * math.cos(lat1) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c


if __name__ == '__main__':

    original_data = []
    with open('data/modified_data.csv', 'rb') as csv_file:
        spam_reader = csv.reader(csv_file)
        for row in spam_reader:
            original_data.append([unicode(r, 'UTF-8') for r in row])
    data = original_data[1:]
    columns = original_data[0]
    del original_data

    # [1]  neighbourhood
    # [9]  latitude
    # [10] longitude
    columns[1] = unicode('distance')

    original_landmarks = []
    with open('data/landmarks.csv', 'rb') as csv_file:
        spam_reader = csv.reader(csv_file)
        for row in spam_reader:
            original_landmarks.append([unicode(r, 'UTF-8') for r in row])
    landmarks = original_landmarks[1:]
    del original_landmarks

    for row in data:
        lat0 = row[9]
        lon0 = row[10]
        dist_count = 0
        for landmark in landmarks:
            lat1 = landmark[1]
            lon1 = landmark[2]
            dist = distance(lat0, lon0, lat1, lon1)
            if dist < 10:
                dist_count += 1
        row[1] = dist_count

    file_path = 'modified_data2.csv'
    if os.path.exists(file_path):
        os.unlink(file_path)
    with open(file_path, 'wb') as csv_file:
        spam_writer = csv.writer(csv_file)
        for row in data:
            spam_writer.writerow(row)
