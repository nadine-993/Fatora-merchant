class GetListRequest{

  String? sorting;
  String? keyword;
  int? skipCount;
  Map<String, dynamic> params = {};
  Map<String, dynamic>?  extraParams;

  GetListRequest(
      {
        this.sorting,
        this.keyword,
        this.skipCount,
        this.extraParams}
      );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(sorting !=null) data['Sorting'] = sorting;
    if(keyword !=null) data['Keyword'] = keyword;
    if(skipCount !=null) data['skipCount'] = skipCount;
    if(extraParams != null) {
      data.addAll(extraParams ?? {});
    }
    return data;
  }
}