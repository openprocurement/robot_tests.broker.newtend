# -*- coding: utf-8 -*-
from datetime import datetime
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange


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
    tender_data.data.procuringEntity['name'] = u"Auction Owner company"
    return tender_data


def convert_nt_string_to_common_string(string):
    return {
        u"кілограми": u"кілограм",
        u"кг.": u"кілограми",
        u"грн.": u"UAH",
        u" з ПДВ": True,
        u"Картонки": u"Картонні коробки",
        u"Уточнение": u"active.enquiries",
        u"Предложения": u"active.tendering",
        u"Аукцион": u"active.auction",
    }.get(string, string)
