# -*- coding: utf-8 -*-
'''
=== 1 ===
bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner

# ok - bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:provider1
# ok - bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:provider1
# ok - bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:provider1

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_active_disqualification.txt -v BROKER:Newtend -v ROLE:viewer

==== 2 ===
bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:provider1

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_payment_cancellation.txt -v BROKER:Newtend -v ROLE:viewer

=== 3 ===
bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s contract_signing -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:tender_owner

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s contract_signing -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:provider1

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s contract_signing -A robot_tests_arguments/dgf_financial_second_award_complete.txt -v BROKER:Newtend -v ROLE:viewer

=== 4 ===
bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:tender_owner

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:provider1

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_cancellation.txt -v BROKER:Newtend -v ROLE:viewer

=== 5 ===
bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:tender_owner

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:provider1
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:provider1

bin/op_tests -s openProcedure -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s auction -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:viewer
bin/op_tests -s awarding -A robot_tests_arguments/dgf_financial_verification_disqualification.txt -v BROKER:Newtend -v ROLE:viewer
'''

from datetime import datetime
from pytz import timezone
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange
import urllib


def substract(dividend, divisor):
    return int(dividend) - int(divisor)


def download_file(url, file_name, output_dir):
    urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))


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
        u'Auction cancelled': u'cancelled',
        u'Торги відмінено': u'cancelled',
        u'Торги отменены': u'cancelled',
        u'Lot cancelled': u'active',
        u'Лот скасовано': u'active',
        u'Completed': u'complete',
        u'Завершен': u'complete',
        u'Завершено': u'complete',
        u'До участі допускаються лише ліцензовані фінансові установи.': u'Only licensed financial institutions are eligible to participate.',
        u'К участию допускаются только лицензированные финансовые учреждения.': u'Only licensed financial institutions are eligible to participate.',
        u'Law requirements': u'dgfFinancialAssets',
        u'Права вимоги за кредитами': u'dgfFinancialAssets',
        u'Майно банків': u'dgfOtherAssets',
        u'Assets of banks': u'dgfOtherAssets',
        u'Юридична Інформація Майданчиків': u'x_dgfPlatformLegalDetails',
        u'Очікує на рішення': u'pending.verification',
        u'Ожидает решения': u'pending.verification',
        u'Expecting decision': u'pending.verification',
        u'Очікує розгляду': u'pending.waiting',
        u'Ожидает рассмотрения': u'pending.waiting',
        u'Expecting consideration': u'pending.waiting',
        u'Очікується оплата': u'active',
        u'Ожидается оплата': u'pactive',
        u'Pending payment': u'active',
        u'Очікує кінця кваліфікації першого учасника': u'pending.waiting',
        u'Ожидает квалификации конца первого участника': u'pending.waiting',
        u'Очікується завантаження та підтвердження протоколу': u'pending.verification',
        u'Ожидается загрузка и подтверждение протокола': u'pending.verification',
        u'Відхилений': u'unsuccessful',
        u'Отклонен': u'unsuccessful',
        u'Refused': u'unsuccessful',
        u'Очікується підписання контракту': u'active',
        u'Ожидается подписание контракта': u'active',
        u'Expected the signing of the contract': u'active',
    }.get(string, string)


'''
payment agree btn      xpath=//button[@ng-click="decide('active')"]
payment confirm modal  xpath=//div[@class="bids-modal ng-scope"]
payment confirm btn    xpath=//button[@ng-click="accept()"]
file upload control    xpath=//div[@ng-file-select=""]

accept offer    xpath=//button[@ng-click="finishVerification(bidAward, tender)"]
accept modal    xpath=//div[@class="bids-modal ng-scope"]
accept btn      xpath=//button[@ng-click="vm.setAwardVerified(vm.files[0], vm.award, vm.tender)"]

expecting payment status      xpath=//div[@class="col-xs-4 status ng-binding pending"]

winner selected status          xpath=//div[@class="col-xs-4 status ng-binding active"]

upload file btn        xpath=//button[@ng-model="files"]
refuse participant btn  xpath=//button[@ng-click="decide('unsuccessful')"]

participant that is refused         xpath=//div[@class="col-xs-4 status ng-binding canceled"]

# new statuses
first place waiting     xpath=//div[@class="col-xs-4 status ng-binding pending-verification"]
second place waiting    xpath=//div[@class="col-xs-4 status ng-binding pending-waiting"]
waiting for payment status    xpath=//div[@class="col-xs-4 status ng-binding pending-payment"]
'''