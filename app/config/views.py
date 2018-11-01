from django.shortcuts import render


def index(request):

    # templates/index.html 파일을 보여주도록 함
    # Root URL('/')에서 이 view로 이동
    # URL name은 'index'사용

    return render(request, 'index.html')