# -*- coding: utf-8 -*-
from datetime import datetime
from pytz import timezone
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange

'''
# Robot tests parallel execution
# Output files are going to be written into certain Log file
# DGF Financial assets
# Newtend Auction Owner ================
# bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_newtend_owner
# bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_newtend_owner
# bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_newtend_owner
# bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_newtend_owner
# ======================================
# Newtend provider =====================
# bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_provider
# bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_provider
# bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_provider
# bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_provider
# ======================================
# Newtend viewer =======================
# bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_viewer
# bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_viewer
# bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_viewer
# bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_viewer
# ======================================

# DGF Other assets
# Newtend Auction Owner ================
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_O_newtend_owner
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_O_newtend_owner
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_O_newtend_owner
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_O_newtend_owner
# ======================================
# Newtend provider =====================
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_O_newtend_provider
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
# ======================================
# Newtend viewer =======================
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer
# ======================================
'''


def newtend_date_picker_index(isodate):
    now = get_now()
    date_str = '01' + str(now.month) + str(now.year)
    first_day_of_month = datetime.strptime(date_str, "%d%m%Y")
    mod = first_day_of_month.isoweekday() - 2
    iso_dt = parse_date(isodate)
    # last_day_of_month = monthrange(now.year, now.month)[1]
    # LOGGER.log_message(Message("last_day_of_month: {}".format(last_day_of_month), "INFO"))
    if now.day > iso_dt.day:
        mod = monthrange(now.year, now.month)[1] + mod
    return mod + iso_dt.day


def update_data_for_newtend(tender_data):
    tender_data.data.procuringEntity['name'] = u"Bank fool name"
    return tender_data


def get_time_with_offset(date):
    date_obj = datetime.strptime(date, "%d-%m-%Y, %H:%M")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    return localized_date.strftime('%Y-%m-%d %H:%M:%S.%f%z')


# def add_timezone_to_date(date_str):
#     new_date = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
#     TZ = timezone(os.environ['TZ'] if 'TZ' in os.environ else 'Europe/Kiev')
#     new_date_timezone = TZ.localize(new_date)
#     return new_date_timezone.strftime("%Y-%m-%d %H:%M:%S%z")


def convert_newtend_date_to_iso_format(date_time_from_ui):
    new_timedata = datetime.strptime(date_time_from_ui, '%Y-%m-%d %H:%M:%S')
    new_timedata.strftime('%d-%m-%Y, %H:%M')
    return new_timedata


def convert_nt_string_to_common_string(string):
    return {
        # Our data: converts to CDB data assertion
        u"кілограми": u"кілограм",
        u"кг.": u"кілограми",
        u"грн.": u"UAH",
        u"c НДС": True,
        u"VAT incl.": True,
        u"Картонки": u"Картонні коробки",
        u"Уточнение": u"active.enquiries",
        u"Предложения": u"active.tendering",
        u"Аукцион": u"active.auction",
        u'Кваліфікація': u'active.qualification',
        u'Qualification': u'active.qualification',
        u'active.awarded': u'active.qualification',
        u"Код відповідного класифікатору лоту": u"CAV",
        u"Житлова нерухомість": u"Житлова  нерухомість",
    }.get(string, string)
