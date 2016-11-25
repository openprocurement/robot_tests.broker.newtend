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
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_Onewtend_owner
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_Onewtend_owner
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_Onewtend_owner
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:tender_owner -L TRACE:INFO -d test_output_Onewtend_owner
# ======================================
# Newtend provider =====================
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:provider -L TRACE:INFO -d test_output_newtend_O_provider
# ======================================
# Newtend viewer =======================
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer_procedure
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer_auction
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer_qualify
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other_simple.txt -v BROKER:Newtend -v ROLE:viewer -L TRACE:INFO -d test_output_newtend_O_viewer_contract
# ======================================
# ========= Auction Cancellation ===============
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_financial_tender_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
# ========= Other assets========
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s cancellation -A robot_tests_arguments/dgf_other_tender_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
# ========= Bid Cancellation ===============
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_bid_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_bid_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial_bid_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_bid_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_bid_cancellation.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other_bid_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
# =========      End         ===============
# ========= Full scenarios =========
bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:tender_owner

bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:provider
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:provider

bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:viewer
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_financial.txt -v BROKER:Newtend -v ROLE:viewer

bin/openprocurement_tests -s openProcedure -A robot_tests_arguments/dgf_other.txt -v BROKER:BrokerName -v ROLE:RoleName
bin/openprocurement_tests -s auction -A robot_tests_arguments/dgf_other.txt -v BROKER:BrokerName -v ROLE:RoleName
bin/openprocurement_tests -s qualification -A robot_tests_arguments/dgf_other.txt -v BROKER:BrokerName -v ROLE:RoleName
bin/openprocurement_tests -s contract_signing -A robot_tests_arguments/dgf_other.txt -v BROKER:BrokerName -v ROLE:RoleName"
'''


def newtend_date_picker_index(isodate):
    now = get_now()
    date_str = '01' + str(now.month) + str(now.year)
    first_day_of_month = datetime.strptime(date_str, "%d%m%Y")
    mod = first_day_of_month.isoweekday() - 2
    iso_dt = parse_date(isodate)
    if now.day > iso_dt.day:
        mod = monthrange(now.year, now.month)[1] + mod
    return mod + iso_dt.day


def update_data_for_newtend(tender_data):
    tender_data.data.procuringEntity['name'] = u"Bank fool name"
    return tender_data


def update_data_for_newtend_new(role_name, tender_data):
    if role_name == 'tender_owner':
        tender_data['data']['procuringEntity']['name'] = u"Bank fool name"
    return tender_data


def get_time_with_offset(date):
    date_obj = datetime.strptime(date, "%Y-%m-%d %H:%M:%S")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    return localized_date.strftime('%Y-%m-%d %H:%M:%S.%f%z')


def convert_newtend_auction_date_format(date_time_from_ui):
    new_time = datetime.strptime(date_time_from_ui, '%Y-%m-%d %H:%M:%S')
    return new_time.strftime('%Y-%m-%d %H:%M:%S')


def add_timezone_to_date(date_str):
    new_date = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(new_date)
    return localized_date.strftime("%Y-%m-%d %H:%M:%S%z")


def convert_newtend_date_to_iso_format(date_time_from_ui):
    new_timedata = datetime.strptime(date_time_from_ui, '%Y-%m-%d %H:%M:%S')
    return new_timedata.strftime("%Y-%m-%d %H:%M:%S")


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
        u"Auction": u"active.auction",
        u'Кваліфікація': u'active.qualification',
        u'Qualification': u'active.qualification',
        u'Cancelled': u'cancelled',
        u'Скасовано': u'cancelled',
        u'Отменен': u'cancelled',
        u'Несостоявшийся': u'unsuccessful',
        u'Не відбувся': u'unsuccessful',
        u'Failed': u'unsuccessful',
        u'Considered': u'',
        u'active.awarded': u'active.qualification',
        u"Код відповідного класифікатору лоту": u"CAV",
        u"Житлова нерухомість": u"Житлова  нерухомість",
        u'Trade canceled': u'active',
        u'Торг скасовано': u'active',
        u'Торг отменен': u'active',
        u'Completed': u'complete',
        u'Завершен': u'complete',
        u'Завершено': u'complete',
        u'До участі допускаються лише ліцензовані фінансові установи.': u'Only licensed financial institutions are eligible to participate.',
        u'К участию допускаются только лицензированные финансовые учреждения.': u'Only licensed financial institutions are eligible to participate.',
    }.get(string, string)
