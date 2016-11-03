# -*- coding: utf-8 -*-
from datetime import datetime
from pytz import timezone
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange


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
        u'Considered': u'',
        u'active.awarded': u'active.qualification',
        u"Код відповідного класифікатору лоту": u"CAV",
        u"Житлова нерухомість": u"Житлова  нерухомість",
    }.get(string, string)
