import 'package:flutter/foundation.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

class ContactsViewModel extends ChangeNotifier {

  PagingSource<int, Contact> getContacts()  {
    return PagingSource(
        localSource: (params)  {
          int offset = params.key ?? 0;
          return Stream.fromFuture(ContactsService.getContacts(withThumbnails: false)).map((event) {
            return Page(event.skip(offset * params.loadSize).take(params.loadSize).toList(), offset, event.length == params.loadSize ? offset + 1 : null);
          });
        }
    );
  }

  PagingSource<int, Contact> searchContacts(String name)  {
    return PagingSource(
        localSource: (params)  {
          int offset = params.key ?? 0;
          return Stream.fromFuture(ContactsService.getContacts(query: name, withThumbnails: false)).map((event) {
            return Page(event.skip(offset * params.loadSize).take(params.loadSize).toList(), offset, event.length == params.loadSize ? offset + 1 : null);
          });
        }
    );
  }

}