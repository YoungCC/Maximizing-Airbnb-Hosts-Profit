# -*- coding:UTF-8 -*-

import os
import csv

if __name__ == '__main__':
    original_data = []

    with open('data/final_newListings.csv', 'rb') as csv_file:
        spam_reader = csv.reader(csv_file)
        i = 0
        for row in spam_reader:
            original_data.append([unicode(r, 'UTF-8') for r in row])
    data = original_data[1:]
    columns = original_data[0]
    del original_data

    # the index required for translate to number normally
    # [1] => neighbourhood
    # [2] => property_type
    # [3] => room_type
    # [8] => bed_type

    # print columns[1], columns[2], columns[3], columns[8]

    column_normal_translate_list_map = {}
    for row in data:
        column_normal_translate_list_map.setdefault('neighbourhood', set()).add(row[1])
        column_normal_translate_list_map.setdefault('property_type', set()).add(row[2])
        column_normal_translate_list_map.setdefault('room_type', set()).add(row[3])
        column_normal_translate_list_map.setdefault('bed_type', set()).add(row[8])

    # print column_normal_translate_list_map

    temp = {}
    for column, string_values in column_normal_translate_list_map.items():
        string_values = list(string_values)
        temp[column] = dict([tuple([string_values[i], i]) for i in range(0, len(string_values))])
    column_normal_translate_list_map = temp
    del temp

    # print column_normal_translate_list_map

    # # output all normal translate column map
    # for column, translate_map in column_normal_translate_list_map.items():
    #     print column + ':'
    #     name_values = translate_map.items()
    #     name_values.sort(key=lambda tup: tup[1])
    #     for name, value in name_values:
    #         if not name:
    #             name = 'None'
    #         print unicode(value).encode('UTF-8'), '=>', unicode(name).encode('UTF-8')
    #     print ''

    # the index required for extended translate
    # [9] => amenities

    # print columns[9]

    amenities = set()
    for row in data:
        for ame in unicode(row[9]).strip('{} ').split(','):
            ame = ame.strip('" ')
            if ame:
                amenities.add(ame)

    amenities = list(amenities)
    amenity_map = dict([tuple([amenities[i], i]) for i in range(0, len(amenities))])

    # # output all amenity translate map
    # name_values = amenity_map.items()
    # name_values.sort(key=lambda tup: tup[1])
    # print columns[9] + ':'
    # for name, value in name_values:
    #     print unicode(value).encode('UTF-8'), '=>', unicode(name).encode('UTF-8')
    # amenities = [name for name, value in name_values]
    # del name_values

    # since amenity has 148 dimensions and the other has 11 dimensions
    # so the total dimension is 159

    modified_data = []
    for row in data:
        temp = []
        temp.extend(row[0:9])
        temp.extend(row[10:])

        temp[1] = column_normal_translate_list_map['neighbourhood'][temp[1]]
        temp[2] = column_normal_translate_list_map['property_type'][temp[2]]
        temp[3] = column_normal_translate_list_map['room_type'][temp[3]]
        temp[8] = column_normal_translate_list_map['bed_type'][temp[8]]

        amenity_list = [x.strip('" ') for x in unicode(row[9]).strip('{} ').split(',')]
        for amenity in amenities:
            if amenity in amenity_list:
                temp.append(1)
            else:
                temp.append(0)
        modified_data.append([unicode(t).encode('UTF-8') for t in temp])

    file_path = 'modified_data.csv'
    if os.path.exists(file_path):
        os.unlink(file_path)
    with open(file_path, 'wb') as csv_file:
        spam_writer = csv.writer(csv_file)
        for row in modified_data:
            spam_writer.writerow(row)

    # for i in range(0, len(modified_data[0])):
    #     if i > 10:
    #         print '[%d]' % i, '=>',  unicode(amenities[i - 11]).encode('UTF-8')
    #     else:
    #         if i < 9:
    #             print '[%d]' % i, '=>', columns[i]
    #         else:
    #             print '[%d]' % i, '=>', columns[i + 1]
