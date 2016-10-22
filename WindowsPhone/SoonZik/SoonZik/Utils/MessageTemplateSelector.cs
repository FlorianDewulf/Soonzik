using Windows.UI.Xaml;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.Utils
{
    public class MessageTemplateSelector : DataTemplateSelector
    {
        public DataTemplate Recu { get; set; }
        public DataTemplate Envoye { get; set; }

        public override DataTemplate SelectTemplate(object item, DependencyObject container)
        {
            var message = item as Message;
            if (message != null)
            {
                if (message.type == "recu")
                {
                    return Recu;
                }
                if (message.type == "envoye")
                {
                    return Envoye;
                }
            }
            return base.SelectTemplate(item, container);
        }
    }
}