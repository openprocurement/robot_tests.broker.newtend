# coding:utf-8
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
    tender_data['data']['items'][0]['unit']['name'] = u"кілограми"
    tender_data['data']['procuringEntity']['name'] = u"ten2312 - changed long name to new one"
    tender_data['data']['answer'] = u"data: answer: Eum quo sit eum deleniti occaecati veniam incidunt aut ratione aut qui" \
                                                    u"dolorem quia minima enim fuga et facere debitis nihil quaerat iste explicabo" \
                                                    u" dolores ullam aliquid dignissimos molestiae minus assumenda deserunt ab et" \
                                                    u" nisi eum tempore sed rerum esse temporibus."
    tender_data['data']['items'][0]['additionalClassifications'][0]['description'] = u'Папір і картон гофровані, паперова й картонна тара'
    return tender_data
