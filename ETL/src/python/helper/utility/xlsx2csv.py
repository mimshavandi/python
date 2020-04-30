import  xlrd, os, csv


def csv_from_excel(excel, sheet, csvfile, in_dir, out_dir):
    exel_path = os.path.join(in_dir , excel)
    wb = xlrd.open_workbook(exel_path)
    sh = wb.sheet_by_name(sheet)
    csv_path = os.path.join(out_dir , csvfile )
    your_csv_file = open(csv_path, 'w')
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))

    your_csv_file.close()
